variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "node_role_arn" {
  description = "The arn of the EKS Nodes Role"
  type = string
}