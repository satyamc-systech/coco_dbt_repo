{{ config(
    materialized='incremental',
    unique_key='policy_id'
) }}

with revenue_reconciled as (

    select * from {{ ref('int__revenue_reconciled') }}

),

final as (

    select
        policy_id,
        policy_number,
        product_line,
        policy_status,
        effective_date,
        state,
        region,
        original_currency,
        exchange_rate_to_usd,

        billing_amount_local,
        gl_amount_local,
        payment_amount_local,
        billing_amount_usd,
        gl_amount_usd,
        payment_amount_usd,

        claim_count,
        payment_count,

        billing_vs_gl_diff_usd,
        gl_vs_payment_diff_usd,
        billing_vs_payment_diff_usd,

        has_billing_gl_discrepancy,
        has_gl_payment_discrepancy,
        has_billing_payment_discrepancy,
        has_any_discrepancy,

        case
            when not has_any_discrepancy then 'RECONCILED'
            when abs(billing_vs_gl_diff_usd) <= 1
                 and abs(gl_vs_payment_diff_usd) <= 1
                 and abs(billing_vs_payment_diff_usd) <= 1
            then 'MINOR_VARIANCE'
            else 'UNRECONCILED'
        end as reconciliation_status,

        abs(billing_vs_gl_diff_usd)
            + abs(gl_vs_payment_diff_usd)
            + abs(billing_vs_payment_diff_usd)
            as total_discrepancy_usd

    from revenue_reconciled

)

select * from final
