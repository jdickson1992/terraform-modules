variable "ecr_names" {
  description = "List of ECR registries to create"
  type        = list(string)
}

variable "tags" {
  description = "Tags for ECR repository"
  type = map(any)
  default = {}
}