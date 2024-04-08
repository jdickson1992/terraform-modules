variable "environment" {
  type        = string
  description = "Environment deploying to."
}

variable "eks_subnets" {
  type    = bool
  default = true # Set default value as needed
}

variable "cluster_name" {
  type        = string
  description = "Name of EKS Cluster."
}

variable "vpc_cidr" {
  type        = string
  default     = "172.16.0.0/16"
  description = "The IPv4 CIDR block for the VPC."
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

variable "private_subnet_count" {
  type        = number
  default     = 3
  description = "Number of Private subnets."
}

variable "public_subnet_count" {
  type        = number
  default     = 3
  description = "Number of Public subnets."
}

variable "public_subnet_additional_bits" {
  type        = number
  default     = 8
  description = "Number of additional bits with which to extend the prefix."
}

variable "private_subnet_additional_bits" {
  type        = number
  default     = 8
  description = "Number of additional bits with which to extend the prefix."
}

variable "private_subnet_tags" {
  description = "Private subnet tags"
  type        = map(any)
  default     = {}
}

variable "public_subnet_tags" {
  description = "Public subnet tags"
  type        = map(any)
  default     = {}
}
