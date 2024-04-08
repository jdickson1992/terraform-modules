output "control_plane_security_group_id" {
  description = "ID of the security group for the EKS cluster control plane"
  value       = aws_security_group.eks_cluster.id
}

output "worker_nodes_security_group_id" {
  description = "ID of the security group for worker nodes"
  value       = aws_security_group.eks_nodes.id
}

output "nodes_launch_template" {
  description = "The ID of the AWS Managed nodes launch template"
  value       = aws_launch_template.eks_node_group.id
}

output "eks_role_arn" {
  description = "The arn of the EKS control plane role"
  value       = aws_iam_role.eks_cluster.arn
}

output "nodes_role_arn" {
  description = "The arn of the EKS Nodes role"
  value       = aws_iam_role.eks_nodes.arn
}

output "eks_secrets_encryption_key" {
  description = "The KMS key ARN used to encrypt K8s secrets"
  value       = aws_kms_key.eks_encryption.arn
}

output "eks_name" {
  description = "The EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "eks_version" {
  description = "The kubernetes version used by EKS"
  value       = aws_eks_cluster.main.version
}

output "eks_cluster_id" {
  description = "The EKS cluster ID"
  value       = aws_eks_cluster.main.id
}

output "eks_cluster_endpoint" {
  description = "The EKS cluster endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "eks_cluster_ca_certificate" {
  description = "The base64 encoded certificate data required to communicate with the cluster"
  value       = base64decode(aws_eks_cluster.main.certificate_authority[0].data)
}

output "eks_cluster_oidc_issuer_url" {
  description = "The URL for the OIDC issuer"
  value       = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "openid_provider_arn" {
  description = "The OIDC ARN of the Cluster"
  value = aws_iam_openid_connect_provider.oidc_provider[0].arn
}

output "openid_provider_id" {
  description = "The OIDC ID of the Cluster"
  value       = aws_iam_openid_connect_provider.oidc_provider[0].id
}

output "openid_provider_url" {
  description = "The OIDC URL of the Cluster"
  value       = aws_iam_openid_connect_provider.oidc_provider[0].url
}
