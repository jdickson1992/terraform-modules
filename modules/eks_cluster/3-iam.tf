############################################################################################################
#                       IAM ROLES (Cluster + Nodes)
############################################################################################################
# Fetching current AWS account details
data "aws_caller_identity" "current" {}

# Creating an IAM role with the EKS principal
resource "aws_iam_role" "eks_cluster" {
  name = "${var.cluster_name}-eks-cluster"

  # Define assume role policy
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Attaching the AmazonEKSClusterPolicy (allows EKS to create EC2 instances / loadbalancers)
resource "aws_iam_role_policy_attachment" "eks_cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

# Creating an IAM role for the worker nodes
resource "aws_iam_role" "eks_nodes" {
  name = "${var.cluster_name}-eks-nodes"

  # Define assume role policy in JSON format
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

# For Load Balancer controller
resource "aws_iam_policy" "lb_controller_policy" {
  name        = "lb-worker-policy-${var.cluster_name}"
  description = "Worker policy for the ALB Ingress"

  policy = file("${path.module}/policies/iam-policy.json")
}

# Iterate over all provided policies and attach them to the nodes IAM role
resource "aws_iam_role_policy_attachment" "nodes" {
  for_each = var.node_iam_policies

  policy_arn = each.value
  role       = aws_iam_role.eks_nodes.name
}

# Attach the lb_controller_policy to the nodes IAM role
resource "aws_iam_role_policy_attachment" "lb_controller_policy_attachment" {
  policy_arn = aws_iam_policy.lb_controller_policy.arn
  role       = aws_iam_role.eks_nodes.name
}


############################################################################################################
### KMS KEY
############################################################################################################

# Creating KMS key for EKS cluster encryption
resource "aws_kms_key" "eks_encryption" {
  description         = "KMS key for EKS cluster encryption"
  policy              = data.aws_iam_policy_document.kms_key_policy.json
  enable_key_rotation = true
}

# Alias for KMS key
resource "aws_kms_alias" "eks_encryption" {
  name          = "alias/eks/${var.cluster_name}"
  target_key_id = aws_kms_key.eks_encryption.id
}

# Define IAM policy document for KMS key
data "aws_iam_policy_document" "kms_key_policy" {
  statement {
    sid = "Key Administrators"
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:TagResource"
    ]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
        data.aws_caller_identity.current.arn
      ]
    }
    resources = ["*"]
  }

  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    resources = ["*"]
  }
}

# Define IAM policy for cluster encryption
resource "aws_iam_policy" "cluster_encryption" {
  name        = "${var.cluster_name}-encryption-policy"
  description = "IAM policy for EKS cluster encryption"
  policy      = data.aws_iam_policy_document.cluster_encryption.json
}

# Define IAM policy document for cluster encryption
data "aws_iam_policy_document" "cluster_encryption" {
  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ListGrants",
      "kms:DescribeKey"
    ]
    resources = [aws_kms_key.eks_encryption.arn]
  }
}

# Granting the EKS Cluster role the ability to use the KMS key
resource "aws_iam_role_policy_attachment" "cluster_encryption" {
  policy_arn = aws_iam_policy.cluster_encryption.arn
  role       = aws_iam_role.eks_cluster.name
}
