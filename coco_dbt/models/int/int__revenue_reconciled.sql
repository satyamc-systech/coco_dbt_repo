{{ config(
    materialized='table'
) }}

with policies as (

    select * from {{ ref('stg__insurance_raw__policies') }}

),

claims as (

    select * from {{ ref('stg__insurance_raw__claims') }}

),

payments as (

    select * from {{ ref('stg__insurance_raw__payments') }}

),

customers as (

    select * from {{ ref('stg__insurance_raw__customers') }}

),

exchange_rates as (

    select * from {{ ref('sd__currency_exchange_rates') }}

),

state_regions as (

    select * from {{ ref('sd__state_region_mapping') }}

),

billing_by_policy as (

    select
        policy_id,
        premium_amount as billing_amount_local
    from policies

),

gl_by_policy as (

    select
        policy_id,
        count(claim_id) as claim_count,
        sum(cast(approved_amount as decimal(14, 2))) as gl_amount_local
    from claims
    group by policy_id

),

payments_by_policy as (

    select
        c.policy_id,
        count(p.payment_id) as payment_count,
        sum(cast(p.payment_amount as decimal(14, 2))) as payment_amount_local
    from payments p
    inner join claims c on p.claim_id = c.claim_id
    group by c.policy_id

),

currency_assignment as (

    select
        pol.policy_id,
        case mod(pol.policy_id, 4)
            when 0 then 'USD'
            when 1 then 'EUR'
            when 2 then 'GBP'
            when 3 then 'CAD'
        end as original_currency
    from policies pol

),

region_mapping as (

    select
        pol.policy_id,
        cust.state,
        coalesce(sr.region, 'Unknown') as region
    from policies pol
    inner join customers cust on pol.customer_id = cust.customer_id
    left join state_regions sr on cust.state = sr.state_code

),

final__revenue_reconciled as (

    select
        pol.policy_id,
        pol.policy_number,
        pol.policy_type as product_line,
        pol.policy_status,
        pol.effective_date,
        rm.state,
        rm.region,

        ca.original_currency,
        er.exchange_rate_to_usd,

        coalesce(b.billing_amount_local, 0) as billing_amount_local,
        coalesce(gl.gl_amount_local, 0) as gl_amount_local,
        coalesce(pay.payment_amount_local, 0) as payment_amount_local,

        round(coalesce(b.billing_amount_local, 0) * er.exchange_rate_to_usd, 2) as billing_amount_usd,
        round(coalesce(gl.gl_amount_local, 0) * er.exchange_rate_to_usd, 2) as gl_amount_usd,
        round(coalesce(pay.payment_amount_local, 0) * er.exchange_rate_to_usd, 2) as payment_amount_usd,

        coalesce(gl.claim_count, 0) as claim_count,
        coalesce(pay.payment_count, 0) as payment_count,

        round(coalesce(b.billing_amount_local, 0) * er.exchange_rate_to_usd, 2)
            - round(coalesce(gl.gl_amount_local, 0) * er.exchange_rate_to_usd, 2)
            as billing_vs_gl_diff_usd,

        round(coalesce(gl.gl_amount_local, 0) * er.exchange_rate_to_usd, 2)
            - round(coalesce(pay.payment_amount_local, 0) * er.exchange_rate_to_usd, 2)
            as gl_vs_payment_diff_usd,

        round(coalesce(b.billing_amount_local, 0) * er.exchange_rate_to_usd, 2)
            - round(coalesce(pay.payment_amount_local, 0) * er.exchange_rate_to_usd, 2)
            as billing_vs_payment_diff_usd,

        case
            when round(coalesce(b.billing_amount_local, 0) * er.exchange_rate_to_usd, 2)
                 != round(coalesce(gl.gl_amount_local, 0) * er.exchange_rate_to_usd, 2)
            then true
            else false
        end as has_billing_gl_discrepancy,

        case
            when round(coalesce(gl.gl_amount_local, 0) * er.exchange_rate_to_usd, 2)
                 != round(coalesce(pay.payment_amount_local, 0) * er.exchange_rate_to_usd, 2)
            then true
            else false
        end as has_gl_payment_discrepancy,

        case
            when round(coalesce(b.billing_amount_local, 0) * er.exchange_rate_to_usd, 2)
                 != round(coalesce(pay.payment_amount_local, 0) * er.exchange_rate_to_usd, 2)
            then true
            else false
        end as has_billing_payment_discrepancy,

        case
            when round(coalesce(b.billing_amount_local, 0) * er.exchange_rate_to_usd, 2)
                 != round(coalesce(gl.gl_amount_local, 0) * er.exchange_rate_to_usd, 2)
                 or round(coalesce(gl.gl_amount_local, 0) * er.exchange_rate_to_usd, 2)
                 != round(coalesce(pay.payment_amount_local, 0) * er.exchange_rate_to_usd, 2)
                 or round(coalesce(b.billing_amount_local, 0) * er.exchange_rate_to_usd, 2)
                 != round(coalesce(pay.payment_amount_local, 0) * er.exchange_rate_to_usd, 2)
            then true
            else false
        end as has_any_discrepancy

    from policies pol
    inner join currency_assignment ca on pol.policy_id = ca.policy_id
    inner join exchange_rates er on ca.original_currency = er.currency_code
    inner join region_mapping rm on pol.policy_id = rm.policy_id
    left join billing_by_policy b on pol.policy_id = b.policy_id
    left join gl_by_policy gl on pol.policy_id = gl.policy_id
    left join payments_by_policy pay on pol.policy_id = pay.policy_id

)

select * from final__revenue_reconciled
