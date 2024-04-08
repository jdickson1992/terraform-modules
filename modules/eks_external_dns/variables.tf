variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "Whether to create k8s namespace with name defined by `namespace`."
}

variable "namespace" {
    description =  "The  namespace in which the external-dns service account will be created."
    type = string
    default = "kube-system"
}

variable "helm_repo" {
  type        = string
  default     = "https://charts.bitnami.com/bitnami"
  description = "Helm repository."
}

variable "helm_chart_version" {
  type        = string
  default     = "6.10.2"
  description = "Version of the Helm chart."
}


variable "zone_id" {
    type = string
    description = "The Route53 zone ID"
}

variable "cluster_openid_provider_arn" {
    description = "The OIDC ARN of the Cluster"
    type = string
}

variable "cluster_openid_provider_url" {
    description = "The OIDC URL of the Cluster"
    type = string
}