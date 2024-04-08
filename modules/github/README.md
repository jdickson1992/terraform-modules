# GitHub Integration Module for AWS

This module sets up a GitHub integration on AWS by creating an OpenID Connect (OIDC) provider, IAM role, and attaching policies for GitHub Actions.

## Prerequisites

- Terraform >= v1.5.0
- AWS provider >= v5.40.0

## Module Structure

It consists of several files:

- `0-versions.tf`: Specifies the Terraform version and required providers.
- `1-data.tf`: Fetches information about the AWS partition, OIDC provider, and generates an IAM policy document.
- `2-oidc-provider.tf`: Creates a new OIDC provider for GitHub integration.
- `3-policy-attachment.tf`: Attaches policies to the IAM role for GitHub integration.
- `variables.tf`: Declares input variables used in the module.
- `outputs.tf`: Defines outputs including the OIDC provider URL and IAM role name.

## Inputs

| Name                             | Description                                                          | Type          | Default       |
| -------------------------------- | -------------------------------------------------------------------- | ------------- | ------------- |
| `github_repositories`            | List of GitHub repository names and their associated branches or patterns. | `list(object)` | `[{"name": "example_repo", "branches": ["main"]}]` |
| `github_organization`            | The name of the GitHub organization.                                | `string`      |               |
| `create_oidc_provider`           | Whether to create a new OIDC provider for GitHub integration.       | `bool`        | `true`        |
| `enabled`                        | Whether the GitHub integration is enabled.                          | `bool`        | `true`        |
| `oidc_provider_url`              | The URL of the OIDC provider for GitHub integration.                | `string`      | `token.actions.githubusercontent.com` |
| `github_iam_role_name`           | The name of the IAM role for GitHub integration.                    | `string`      | `github-actions-role` |
| `github_iam_role_path`           | The path to the IAM role for GitHub integration.                    | `string`      | `/`           |
| `github_iam_role_policy_arns`    | List of IAM policy ARNs to attach to the IAM role for GitHub integration. | `list(string)` | `[]`          |
| `max_session_duration`           | The maximum session duration in seconds for the IAM role.            | `number`      | `3600`        |
| `github_integration_tags`        | Map of tags to be applied to all resources for GitHub integration.   | `map(string)` | `{}`          |

## Outputs

| Name                       | Description                          |
| -------------------------- | ------------------------------------ |
| `oidc_provider_url`        | URL of the OIDC provider for GitHub integration. |
| `iam_role_name`            | Name of the IAM role for GitHub integration.     |

## Usage

```hcl
module "github_integration" {
  source = "./modules/github"

  github_organization         = "example_org"
  create_oidc_provider        = true
  enabled                     = true
  oidc_provider_url           = "token.actions.githubusercontent.com"
  github_iam_role_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  github_integration_tags     = {
                                  Environment = "prod"
                                }
}
