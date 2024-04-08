variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "enable_cluster_autoscaler" {
  description = "Install cluster autoscaler"
  type        = bool
  default     = true
}

variable "cluster_openid_provider_arn" {
    description = "The OIDC ARN of the Cluster"
    type = string
}

variable "cluster_openid_provider_url" {
    description = "The OIDC URL of the Cluster"
    type = string
}

variable "cluster_autoscaler_helm_version" {
  description = "Cluster Autoscaler Helm verion"
  type        = string
}

# variable "cluster_role_arn" {
#   description = "The arn of the EKS control plane role"
#   type = string
# }