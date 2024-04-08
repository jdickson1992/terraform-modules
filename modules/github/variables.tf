
variable "github_organization" {
  description = "The name of the GitHub organization"
  type        = string
}

variable "create_oidc_provider" {
  description = "Whether to create a new OIDC provider for GitHub integration"
  type        = bool
  default     = true
}

variable "enabled" {
  description = "Whether the GitHub integration is enabled"
  type        = bool
  default     = true
}

variable "oidc_provider_url" {
  description = "The URL of the OIDC provider for GitHub integration"
  type        = string
  default     = "token.actions.githubusercontent.com"
}

variable "github_iam_role_policy_arns" {
  description = "List of IAM policy ARNs to attach to the IAM role for GitHub integration"
  type        = list(string)
  default     = []
}

variable "github_integration_tags" {
  description = "Map of tags to be applied to all resources for GitHub integration"
  type        = map(string)
  default     = {}
}
