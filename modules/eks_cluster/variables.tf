variable "environment" {
  description = "The environment"
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the EKS cluster resides"
  type        = string
}

variable "node_iam_policies" {
  description = "List of IAM Policies to attach to EKS-managed nodes."
  type        = map(any)
  default = {
    1 = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    2 = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    3 = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    4 = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}

variable "eks_version" {
  description = "Name of the cluster"
  type        = string
  default     = "1.29"
}

variable "whitelist_ips" {
  description = "A list of CIDR ranges that can access the API externally"
  type        = list(string)
  default     = []
}

variable "whitelist_workstation_ip" {
  description = "Will whitelist the IP of your personal workstation allowing access to the Kube API"
  type        = bool
  default     = true
}

variable "private_subnets" {
  description = "Private Subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public Subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "enable_irsa" {
  description = "Determines whether to create an OpenID Connect Provider for EKS to enable IRSA"
  type        = bool
  default     = true
}

variable "node_groups" {
  description = "Map of maps specifying managed node groups"
  type = map(object({
    name : string
    capacity_type : string
    desired_size : number
    min_size : number
    max_size : number
    instance_types : list(string)
  }))
  default = {}
}

variable "default_ami_type" {
  description = "The type of AMI to use for the node group. Valid values: AL2_x86_64, AL2_x86_64_GPU"
  type        = string
  default     = "AL2_x86_64"
}

variable "cluster_addons" {
  description = "List of strings specifying cluster addons"
  type        = list(string)
  default     = ["vpc-cni", "kube-proxy", "coredns", "aws-ebs-csi-driver"]
}

# variable "cluster_autoscaler_helm_version" {
#   description = "Cluster Autoscaler Helm verion"
#   type        = string
# }

# variable "enable_cluster_autoscaler" {
#   description = "Install cluster autoscaler"
#   type        = bool
#   default     = true
# }