############################################################################################################
### CLUSTER ROLE BASE ACCESS CONTROL
############################################################################################################
# Fetch current AWS account details
data "aws_caller_identity" "current" {}

# Define IAM Role for EKS Administrators
resource "aws_iam_role" "eks_admins_role" {
  name = "${var.cluster_name}-eks-admins-role"

  assume_role_policy = data.aws_iam_policy_document.eks_admins_assume_role_policy_doc.json
}

# IAM Policy Document for assuming the eks-admins role
data "aws_iam_policy_document" "eks_admins_assume_role_policy_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    effect = "Allow"
  }
}

# Create IAM Policy for allowing devops group to assume eks_admins_role
data "aws_iam_policy_document" "eks_admins_assume_role_policy_devops_doc" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = [aws_iam_role.eks_admins_role.arn]
    effect    = "Allow"
  }
}

# Create IAM Policy for administrative actions on EKS
data "aws_iam_policy_document" "eks_admin_policy_doc" { #tfsec:ignore:aws-iam-no-policy-wildcards
  statement {
    actions   = ["eks:*", "ec2:Describe*", "iam:ListRoles", "iam:ListRolePolicies", "iam:GetRole"]
    resources = ["*"]
  }
}

# Create IAM Policy based on the above document
resource "aws_iam_policy" "eks_admin_policy" {
  name   = "${var.cluster_name}-eks-admin-policy"
  policy = data.aws_iam_policy_document.eks_admin_policy_doc.json
}

# Attach IAM Policy to the EKS Administrators Role
resource "aws_iam_role_policy_attachment" "eks_admin_role_policy_attach" {
  role       = aws_iam_role.eks_admins_role.name
  policy_arn = aws_iam_policy.eks_admin_policy.arn
}

# Create a devops group
resource "aws_iam_group" "group" {
  name = "devops"
}

# Create IAM Policy based on the document allowing devops group to assume eks_admins_role
resource "aws_iam_policy" "eks_admins_assume_role_policy_devops" {
  name   = "${aws_iam_group.group.name}-eks-admins-assume-role-policy"
  policy = data.aws_iam_policy_document.eks_admins_assume_role_policy_devops_doc.json
}

# Attach IAM Policy to the devops group
resource "aws_iam_group_policy_attachment" "group-attach" {
  group      = aws_iam_group.group.name
  policy_arn = aws_iam_policy.eks_admins_assume_role_policy_devops.arn
}

# Update the aws-auth ConfigMap to include the IAM group
# kubernetes_config_map_v1_data 
resource "kubernetes_config_map_v1_data" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = aws_iam_role.eks_admins_role.arn
        username = aws_iam_role.eks_admins_role.name
        groups   = ["system:masters"]
      },
      {
        rolearn  = var.node_role_arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers", "system:nodes"]
      }
    ])
    mapUsers = yamlencode([
      {
        userarn  = data.aws_caller_identity.current.arn
        username = split("/", data.aws_caller_identity.current.arn)[1]
        groups   = ["system:masters"]
      }
    ])
  }

  force = false
}
