############################################################################################################
#                                    EKS CLUSTER
############################################################################################################

# Retrieves the public IP of the workstation
data "http" "myip" {
  provider = hashicorp-http
  url = "http://ipv4.icanhazip.com"
}

# Define local variable for the workstation's IP CIDR block, if whitelisting is enabled
locals {
  workstation_ip_cidr = var.whitelist_workstation_ip ? ["${chomp(data.http.myip.response_body)}/32"] : []
}

# Create an EKS cluster
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  version  = var.eks_version
  role_arn = aws_iam_role.eks_cluster.arn

  # VPC configuration for the cluster
  vpc_config {
    subnet_ids              = concat(var.private_subnets, var.public_subnets) # Combine private and public subnets
    security_group_ids      = [aws_security_group.eks_cluster.id] # Security group ID
    endpoint_public_access  = true #tfsec:ignore:aws-eks-no-public-cluster-access
    endpoint_private_access = length(var.whitelist_ips) != 0 ? true : ( var.whitelist_workstation_ip ? true : false ) # Enable private access to the API server based on whitelist IPs or workstation IP

    # Define public access CIDRs based on whitelist IPs or workstation IP
    public_access_cidrs = length(var.whitelist_ips) != 0 ? (
      var.whitelist_workstation_ip ? concat(var.whitelist_ips, local.workstation_ip_cidr) : var.whitelist_ips) : (
        var.whitelist_workstation_ip ? local.workstation_ip_cidr : ["0.0.0.0/0"]
    )
  }

  # Encryption configuration for the cluster
  encryption_config {
    provider {
      key_arn = aws_kms_key.eks_encryption.arn
    }
    resources = ["secrets"]
  }
}
