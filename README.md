# Lambda Template

This is a GitHub template repository that provides base infrastructure and application code to develop and deploy AWS Lambda function(s).

## Template Instructions

1. Create a new private GitHub repo `my-project` from this template repository, with "Include all branches" disabled.
2. Under Settings -> Manage access, add the following teams.
   - `BetterOfficeApps/admin-team` - Role: Admin
   - `BetterOfficeApps/bots` - Role: Write
   - `BetterOfficeApps/developers` - Role: Write
   - `BetterOfficeApps/platform-engineering` - Role: Admin
   - `BetterOfficeApps/product` - Role: Read
3. Under Settings -> Branches, add a branch protection rule for `main`:
   - Enable "Require pull request reviews before merging" with 1 review
   - Enable "Dismiss stale pull request approvals when new commits are pushed"
   - Enable "Require review from Code Owners"
   - Enable "Require status checks to pass before merging" (You'll have to come back later to require specific checks once they exist)
   - (Optional) "Require branches to be up to date before merging" is encouraged on smaller repos where you don't expect it to be disruptive.
   - Enable "Include adminstrators"
4. Under Settings -> Options:
   - (Optional) Disable "Wikis", "Issues" and "Projects" if you don't intend to use those features and would like them hidden.
   - Disable "Allow merge commits" and "Allow rebase merging", leaving only "Allow squash merging" enabled.
   - Enable "Automatically delete head branches"
5. Ask Platform Engineering to add the following AWS keys and Terraform API token added to the repo Secrets. This will depend on which AWS accounts you intend to deploy to.
   - `AWS_ACCESS_KEY_ID_PRODUCTION` or `AWS_ACCESS_KEY_ID_BI`
   - `AWS_ACCESS_KEY_ID_STAGING`
   - `AWS_ACCESS_KEY_ID_DEVELOPMENT`
   - `AWS_SECRET_ACCESS_KEY_PRODUCTION` or `AWS_SECRET_ACCESS_KEY_BI`
   - `AWS_SECRET_ACCESS_KEY_STAGING`
   - `AWS_SECRET_ACCESS_KEY_DEVELOPMENT`
   - `TERRAFORM_API_TOKEN`
6. Generally speaking, you should be able to search for all instances of `hello` (case-insensitive) in this codebase for where you need to make the appropriate substitutions for this project.
7. Additionally, make sure to replace any instances of `SENTRY_DSN` with an updated key. See [New Lambda Functions](#New-Lambda-Functions) for more information.
8. Remove this "Template Instructions" section from the README and update the "Lambda Template" header and intro to your project. Replace any instances of `my-project` in this README with your project name.

## New Environment Setup

For each new environment, you will need to create a new Terraform workspace for that environment:

1. Create a Terraform workspace named `my-project-<ENV>-ca-central-1`.
2. Set the Terraform version to the version found in [.terraform-version](.terraform-version).
3. Add the following Terraform variables to the workspace.
   - `environment: <ENV>`
4. Add the following Environment variables to the workspace. You will need to ask Platform Engineering to add the Sensitive variables.
   - `AWS_REGION: ca-central-1`
   - `AWS_ACCESS_KEY_ID` (Sensitive)
   - `AWS_SECRET_ACCESS_KEY` (Sensitive)
   - `DD_API_KEY` (Sensitive)
   - `DD_APP_KEY` (Sensitive)

You will then need to deploy to that environment:

1. Add the new environment to `branches` in [deploy.yml](.github/workflows/deploy.yml).
2. Deploy by force pushing to that branch, and reviewing the run in GitHub Actions. See the [Deployment](#Deployment) section for details.

## Deployment

Deployments are done using GitHub Actions. This is an all-in-one deployment that includes infrastructure and application. To deploy to an environment, force push to the appropriate branch:

```
git push -f origin HEAD:xandev
```

Pushes to `main` branch are automatically deployed to production environment(s). (Note: this has to be enabled by uncommenting the line in [deploy.yml](.github/workflows/deploy.yml) once you have your production workspaces set up)

## Local Development

Look at each lambda function's Makefile for a list of options. The simplest way to get started is with:

```
make install
make run
```

You can then invoke the lambda function by sending a curl request:

```
curl -XPOST "http://localhost:5700/2015-03-31/functions/function/invocations" -d '{"key": "value"}'
```

The port used in this request is determined by how the lambda function is configured in its `docker-compose.yml` file.

As your application matures, you may wish to setup a [Postman](https://www.postman.com/) workspace for these requests, which might be easier to manage and test with a variety of payloads.

## New Lambda Functions

When you create a new Lambda function, you will need to create a new [Sentry](https://sentry.io/organizations/lendesk/projects/new/) "AWS Lambda (Node)" project named `my-project-my-function`. Use the Sentry DSN for your new `aws_lambda_function` Terraform resource. Each Lambda function should have its own Sentry project.
