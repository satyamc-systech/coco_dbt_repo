# Setting Up an Existing dbt Cloud Project in Snowflake Workspaces

This guide walks you through bringing an existing dbt project (from a Git repo used in dbt Cloud) into Snowflake Workspaces, developing against it, deploying changes, and scheduling runs.

---

## Prerequisites

- A Snowflake account with **ACCOUNTADMIN** (or a role with sufficient privileges).
- Personal databases enabled at the account level (required for Workspaces).
- An existing dbt project in a Git repository (GitHub, GitLab, Bitbucket, etc.).
- The repository must contain at least one branch (empty repos are not supported).
- A warehouse available for running dbt commands.
- The target database and schema referenced in `profiles.yml` must already exist in Snowflake.

---

## Part 1: Connect Your Git Repository to Snowflake

### Option A: Using the Snowsight UI

1. Sign in to **Snowsight**.
2. Go to **Projects > Workspaces**.
3. Select **From Git repository**.
4. Paste the HTTPS URL of your repository (e.g., `https://github.com/my-org/my-dbt-project.git`).
5. Optionally rename the workspace.
6. Select an **API Integration** from the dropdown (see [Creating an API Integration](#creating-an-api-integration) below if you don't have one).
7. Choose an authentication method:
   - **OAuth2** — Click "Sign in", authorize the Snowflake GitHub App, and grant read/write access to code.
   - **Personal access token** — Select the database/schema containing your secret, or create a new one.
   - **Public repository** — Select this for public repos (read-only; you cannot push changes).
8. Select **Create**.

### Option B: Using SQL (CLI / Worksheet)

#### Step 1: Create a Secret (if the repo requires authentication)

```sql
CREATE OR REPLACE SECRET my_db.my_schema.my_git_secret
  TYPE = password
  USERNAME = 'your_username'
  PASSWORD = 'ghp_your_personal_access_token';
```

#### Step 2: Create an API Integration

```sql
CREATE OR REPLACE API INTEGRATION my_git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/my-org')
  ALLOWED_AUTHENTICATION_SECRETS = (my_db.my_schema.my_git_secret)
  ENABLED = TRUE;
```

For **OAuth2 with GitHub** (no secret needed):

```sql
CREATE OR REPLACE API INTEGRATION my_git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com')
  API_USER_AUTHENTICATION = (TYPE = SNOWFLAKE_GITHUB_APP)
  ENABLED = TRUE;
```

#### Step 3: Create the Git Repository Object

```sql
CREATE OR REPLACE GIT REPOSITORY my_db.my_schema.my_dbt_repo
  API_INTEGRATION = my_git_api_integration
  GIT_CREDENTIALS = my_db.my_schema.my_git_secret
  ORIGIN = 'https://github.com/my-org/my-dbt-project.git';
```

#### Step 4: Create a Workspace from the Git Repository

After creating the Git repository object, go to **Snowsight > Projects > Workspaces > From Git repository** and follow the UI steps (Option A) using the same API integration and credentials.

### Option C: Using Snowflake CLI

```bash
snow git setup my_dbt_repo
```

Follow the interactive prompts to provide the origin URL, secret, and API integration.

---

## Part 2: Configure Your dbt Project for Snowflake

Your dbt project **must** have a `profiles.yml` file. Unlike dbt Core, the `account` and `user` fields can be empty strings — the project runs under the current Snowflake session context.

### Example `profiles.yml`

```yaml
my_dbt_project:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: ""
      user: ""
      database: MY_DATABASE
      schema: MY_SCHEMA
      warehouse: MY_WAREHOUSE
      role: MY_ROLE
    prod:
      type: snowflake
      account: ""
      user: ""
      database: PROD_DATABASE
      schema: PROD_SCHEMA
      warehouse: PROD_WAREHOUSE
      role: PROD_ROLE
```

> **Important:** The target schema must already exist in Snowflake before you compile or run the project. Remove any passwords from `profiles.yml` — they are not needed and will block deployment.

---

## Part 3: Run the dbt Project in a Workspace

### Using the Snowsight UI

1. Open your workspace in **Projects > Workspaces**.
2. Confirm the correct **Project** and **Profile** are selected in the menu bar.
3. Open the **Output** tab at the bottom of the editor.
4. From the command dropdown, select and run:
   - `dbt deps` — Install packages/dependencies.
   - `dbt compile` — Validate the project compiles.
   - `dbt run` — Materialize all models.
   - `dbt test` — Run tests.
   - `dbt build` — Run + test in dependency order.
5. You can add flags in the command input, e.g., `--select my_model+ --target dev`.

### Using the Workspace CLI (Terminal in Workspace)

Within the workspace terminal, run dbt commands directly:

```bash
dbt deps
dbt compile
dbt run --select my_model
dbt test
dbt build --full-refresh
```

---

## Part 4: Develop and Push Changes to a Branch

### Using the Snowsight UI

1. In your workspace, select the **Changes** tab at the top of the folder view.
2. To create a new branch: select the branch dropdown > **+ New** > enter a name > **Create**.
3. To switch branches: select the branch dropdown > choose the target branch.
4. Make your edits (add/modify models, tests, macros, etc.).
5. Modified files appear with **M** (modified), **A** (added), or **D** (deleted) indicators.
6. Select a file to view a visual diff.
7. Write a **commit message** in the text field.
8. Select **Push** to commit and push to the remote repository.
9. If conflicts are detected, select **Pull** first, resolve conflicts inline, then push again.

### Using the Snowflake CLI

```bash
# Fetch latest changes
snow git fetch my_dbt_repo

# List branches
snow git list-branches my_dbt_repo
```

> **Note:** Full Git operations (commit, push, branch creation) are best done through the Snowsight Workspace UI or your local Git client. The Snowflake CLI `snow git` commands focus on fetching and listing.

---

## Part 5: Deploy the dbt Project Object

A **dbt project object** is a versioned, schema-level Snowflake object that packages your dbt project for execution and scheduling.

### Option A: Deploy from the Snowsight Workspace UI

1. Open your workspace.
2. Run `dbt deps` and `dbt compile` to verify the project is valid.
3. In the top right, select **Connect > Deploy dbt project**.
4. Choose a **database** and **schema** for the dbt project object.
5. Select **Create dbt project**, enter a name and description.
6. Optionally set a **default target** (e.g., `prod`).
7. Optionally enable **Run dbt deps** with an external access integration.
8. Select **Deploy**.

To update an existing deployment:

1. Select **Connect > Redeploy dbt project**.
2. This creates a new version (e.g., `VERSION$2`, `VERSION$3`, etc.).

### Option B: Deploy Using SQL

**Create a new dbt project object from a Git repo stage:**

```sql
CREATE DBT PROJECT my_db.my_schema.my_dbt_project
  FROM '@my_db.my_schema.my_dbt_repo/branches/main'
  DEFAULT_TARGET = 'prod'
  COMMENT = 'Production dbt project.';
```

**Update the project (add a new version):**

```sql
-- Fetch latest code from remote
ALTER GIT REPOSITORY my_db.my_schema.my_dbt_repo FETCH;

-- Add a new version from the updated branch
ALTER DBT PROJECT my_db.my_schema.my_dbt_project
  ADD VERSION
  FROM '@my_db.my_schema.my_dbt_repo/branches/main';
```

### Option C: Deploy Using Snowflake CLI

```bash
# Deploy from the current directory
snow dbt deploy my_dbt_project

# Deploy from a specific directory with options
snow dbt deploy my_dbt_project \
  --source /path/to/dbt/project \
  --default-target prod \
  --force
```

---

## Part 6: Execute the dbt Project Object

### Using SQL

```sql
-- Run all models
EXECUTE DBT PROJECT my_db.my_schema.my_dbt_project
  ARGS = 'run --target prod';

-- Run specific models
EXECUTE DBT PROJECT my_db.my_schema.my_dbt_project
  ARGS = 'run --select my_model+ --target prod';

-- Test models
EXECUTE DBT PROJECT my_db.my_schema.my_dbt_project
  ARGS = 'test --target prod';

-- Build (run + test)
EXECUTE DBT PROJECT my_db.my_schema.my_dbt_project
  ARGS = 'build --target prod';
```

### Using Snowflake CLI

```bash
# Execute dbt run
snow dbt execute my_dbt_project run

# Execute dbt test
snow dbt execute my_dbt_project test

# Execute with flags
snow dbt execute my_dbt_project run --select my_model+ --target prod

# Async execution
snow dbt execute --run-async my_dbt_project build
```

---

## Part 7: Schedule dbt Project Runs with Tasks

### Using the Snowsight UI

1. In your workspace, select **Connect > Create schedule**.
2. Enter a **schedule name**.
3. Choose a **frequency** (Hourly, Daily, Weekly, Monthly, or Custom cron).
4. Select the **dbt command** (run, build, test, etc.).
5. Select the **profile** from `profiles.yml`.
6. Add any **additional flags** (e.g., `--select my_model+`).
7. Select **Create**.

To view schedules: **Connect > View schedules**.

### Using SQL

```sql
-- Create a task to run dbt every 6 hours
CREATE OR ALTER TASK my_db.my_schema.run_dbt_project
  WAREHOUSE = MY_WAREHOUSE
  SCHEDULE = '6 hours'
AS
  EXECUTE DBT PROJECT my_db.my_schema.my_dbt_project
    ARGS = 'run --target prod';

-- Create a dependent task to test after each run
CREATE OR ALTER TASK my_db.my_schema.test_dbt_project
  WAREHOUSE = MY_WAREHOUSE
  AFTER my_db.my_schema.run_dbt_project
AS
  EXECUTE DBT PROJECT my_db.my_schema.my_dbt_project
    ARGS = 'test --target prod';

-- Resume the tasks (tasks are created in suspended state)
ALTER TASK my_db.my_schema.test_dbt_project RESUME;
ALTER TASK my_db.my_schema.run_dbt_project RESUME;
```

> **Note:** Serverless tasks cannot run dbt projects. You must specify a user-managed warehouse.

---

## Part 8: Monitor dbt Project Runs

### Snowsight UI

1. Navigate to **Transformation > dbt Projects**.
2. View run history, status (Succeeded/Failed/Executing), command, and parameters.
3. Select a project to see detailed run history.
4. Select a run to see job details, stdout output, and trace information.
5. Select the **Query ID** to view the full query profile.

### Enable Monitoring (SQL)

```sql
ALTER SCHEMA my_db.my_schema SET LOG_LEVEL = 'INFO';
ALTER SCHEMA my_db.my_schema SET TRACE_LEVEL = 'ALWAYS';
ALTER SCHEMA my_db.my_schema SET METRIC_LEVEL = 'ALL';
```

### Access Logs and Artifacts Programmatically

```sql
-- Get the latest query ID for a dbt project run
SET latest_query_id = (
  SELECT query_id
  FROM TABLE(INFORMATION_SCHEMA.DBT_PROJECT_EXECUTION_HISTORY())
  WHERE OBJECT_NAME = 'MY_DBT_PROJECT'
  ORDER BY query_end_time DESC LIMIT 1
);

-- View run logs
SELECT SYSTEM$GET_DBT_LOG($latest_query_id);

-- Get artifact location (manifest.json, compiled SQL, etc.)
SELECT SYSTEM$LOCATE_DBT_ARTIFACTS($latest_query_id);

-- Get ZIP archive URL
SELECT SYSTEM$LOCATE_DBT_ARCHIVE($latest_query_id);
```

---

## Part 9: CI/CD with Snowflake CLI

You can integrate `snow dbt` commands into your CI/CD pipelines (GitHub Actions, GitLab CI, etc.) without needing a Git repository object in Snowflake.

### Example GitHub Actions Workflow

```yaml
name: dbt CI/CD
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  dbt-deploy-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Snowflake CLI
        uses: Snowflake-Labs/snowflake-cli-action@v1

      - name: Deploy and run dbt project
        run: |
          snow dbt deploy my_dbt_project --force
          snow dbt execute my_dbt_project run
          snow dbt execute my_dbt_project test
```

---

## Quick Reference: Creating an API Integration

For **GitHub (OAuth, simplest)**:

```sql
CREATE OR REPLACE API INTEGRATION my_git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com')
  API_USER_AUTHENTICATION = (TYPE = SNOWFLAKE_GITHUB_APP)
  ENABLED = TRUE;
```

For **Token-based auth (any provider)**:

```sql
CREATE OR REPLACE SECRET my_db.my_schema.my_git_secret
  TYPE = password
  USERNAME = 'your_username'
  PASSWORD = 'your_personal_access_token';

CREATE OR REPLACE API INTEGRATION my_git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/my-org')
  ALLOWED_AUTHENTICATION_SECRETS = (my_db.my_schema.my_git_secret)
  ENABLED = TRUE;
```

For **public repos (no auth)**:

```sql
CREATE OR REPLACE API INTEGRATION my_git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/my-org')
  ENABLED = TRUE;
```

---

## Supported dbt Commands in Snowflake

| Command       | Workspaces | EXECUTE DBT PROJECT | snow dbt execute |
|---------------|:----------:|:-------------------:|:----------------:|
| build         | ✔          | ✔                   | ✔                |
| compile       | ✔          | ✔                   | ✔                |
| deps          | ✔          | ✔                   | ✔                |
| docs generate | ✔          | ✔                   | ✗                |
| list          | ✔          | ✔                   | ✔                |
| parse         | ✗          | ✔                   | ✔                |
| run           | ✔          | ✔                   | ✔                |
| retry         | ✔          | ✗                   | ✗                |
| run-operation | ✔          | ✔                   | ✔                |
| seed          | ✔          | ✔                   | ✔                |
| show          | ✔          | ✔                   | ✔                |
| snapshot      | ✔          | ✔                   | ✔                |
| test          | ✔          | ✔                   | ✔                |
