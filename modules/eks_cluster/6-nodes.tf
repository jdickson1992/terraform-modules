############################################################################################################
###                      EKS MANAGED WORKER NODES                                                        ###
############################################################################################################

# Create EKS managed instance groups
resource "aws_eks_node_group" "main" {
  for_each = var.node_groups # Iterate over all provided node groups

  cluster_name    = aws_eks_cluster.main.name
  node_group_name = each.value.name
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.private_subnets

  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }

  update_config {
    max_unavailable = 1
  }

  launch_template {
    id      = aws_launch_template.eks_node_group.id
    version = "$Latest"
  }

  capacity_type        = each.value.capacity_type
  instance_types       = each.value.instance_types
  ami_type             = var.default_ami_type
  force_update_version = true

  # Adding labels allows us to use NodeSelector or affinity to bind pods with nodes
  labels = {
    role = each.key
  }
}