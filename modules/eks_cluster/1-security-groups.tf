############################################################################################################
#                                SECURITY GROUP (Cluster)
############################################################################################################

# Security group for the EKS cluster
resource "aws_security_group" "eks_cluster" {
  name        = "${var.cluster_name}-eks-cluster-sg"
  description = "Controls communication with worker nodes"
  vpc_id      = var.vpc_id

  # Ensure the new security group is created before destroying the old one
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.cluster_name}-eks-cluster-sg"
  }
}

############################################################################################################
#                                INGRESS RULES (Cluster)
# - Allows worker nodes to hit the Kubernetes API on port 443
############################################################################################################

# Ingress rule to allow worker nodes to access the Kubernetes API endpoint
resource "aws_security_group_rule" "eks_cluster_ingress" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  description              = "Allows inbound traffic from worker nodes to the Kubernetes API endpoint port"
}

############################################################################################################
#                                EGRESS RULES (Cluster)
# - Allows the control plane to communicate with the kubelet running on each worker node
############################################################################################################

# Egress rule to allow the control plane to communicate with kubelet
resource "aws_security_group_rule" "eks_cluster_egress_kubelet" {
  type                     = "egress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  description              = "Allows control plane to node egress for kubelet"
}

############################################################################################################
#                                SECURITY GROUP (Managed Nodes)
############################################################################################################

# Security group for the managed nodes in the EKS cluster
resource "aws_security_group" "eks_nodes" {
  name        = "${var.cluster_name}-eks-nodes-sg"
  description = "Security group for all worker nodes in the cluster"
  vpc_id      = var.vpc_id

  tags = {
    Name                                        = "${var.cluster_name}-eks-worker-nodes-sg"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

############################################################################################################
#                                INGRESS RULES (Nodes)
# - CoreDNS ingress access on port 53 via TCP / UDP
# - Control plane can communicate with the kubelet running on each node
# - Allow worker nodes to communicate among themselves
############################################################################################################

# Ingress rule for CoreDNS TCP traffic
resource "aws_security_group_rule" "eks_nodes_ingress_coredns_tcp" {
  type              = "ingress"
  from_port         = 53
  to_port           = 53
  protocol          = "tcp"
  security_group_id = aws_security_group.eks_nodes.id
  self              = true
  description       = "Allows worker nodes to communicate with each other for CoreDNS TCP"
}

# Ingress rule for CoreDNS UDP traffic
resource "aws_security_group_rule" "eks_nodes_ingress_coredns_udp" {
  type              = "ingress"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  security_group_id = aws_security_group.eks_nodes.id
  self              = true
  description       = "Allows worker nodes to communicate with each other for CoreDNS UDP"
}

# Ingress rule for kubelet
resource "aws_security_group_rule" "eks_nodes_ingress_kubelet" {
  type                     = "ingress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_cluster.id
  description              = "Allows control plane to node ingress for kubelet"
}

# Load Balancer controller
resource "aws_security_group_rule" "eks_nodes_ingress_loadbalancer" {
  type                     = "ingress"
  from_port                = 9443
  to_port                  = 9443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_cluster.id
  description              = "Allow access from control plane to webhook port of AWS load balancer controller"
}

# Ingress rule for intercommunication among nodes
resource "aws_security_group_rule" "eks_nodes_intercommunication_ingress" {
  type              = "ingress"
  from_port         = 1025
  to_port           = 65535
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.eks_nodes.id
  description       = "Allows worker nodes to communicate with each other on ephemeral ports"
}

############################################################################################################
#                                EGRESS RULES (Nodes)
# - Allow outbound internet access
############################################################################################################

# Egress rule for outbound internet access
resource "aws_security_group_rule" "eks_nodes_egress_internet" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:aws-ec2-no-public-egress-sgr
  security_group_id = aws_security_group.eks_nodes.id
  description       = "Allows outbound internet access"
}

############################################################################################################
#                                SSM variables
# - Uploads outputs to SSM Parameter store
############################################################################################################

# Upload EKS cluster security group ID
resource "aws_ssm_parameter" "eks_cluster" {
  name        = "/${var.environment}-iac/security_groups/eks_cluster_sg_id"
  description = "Security group ID for the EKS cluster"
  type        = "String"
  value       = aws_security_group.eks_cluster.id

  tags = {
    Name = "${var.environment}-eks-cluster-sg-id"
  }
}

# Upload EKS managed nodes security group ID
resource "aws_ssm_parameter" "eks_nodes" {
  name        = "/${var.environment}-iac/security_groups/eks_nodes_sg_id"
  description = "Security group ID for the EKS managed nodes"
  type        = "String"
  value       = aws_security_group.eks_nodes.id

  tags = {
    Name = "${var.environment}-eks-nodes-sg-id"
  }
}
