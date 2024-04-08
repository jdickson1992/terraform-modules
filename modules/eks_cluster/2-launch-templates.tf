############################################################################################################
#                       LAUNCH TEMPLATES (Nodes)
############################################################################################################

# Launch template for creating EC2 instances in the EKS node group
resource "aws_launch_template" "eks_node_group" {
  name_prefix = "${var.cluster_name}-eks-node-group-lt"
  description = "Launch template for ${var.cluster_name} EKS node group"

  # Attach the security group for the EKS node group
  vpc_security_group_ids = [aws_security_group.eks_nodes.id]

  # Tags applied to instances created from this launch template
  tag_specifications {
    resource_type = "instance"
    tags = {
      "Name" = "${var.cluster_name}-eks-node-group"
    }
  }

  # Metadata options for the EC2 instances
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "enabled"
  }

  # Block device mappings for the EC2 instances
  block_device_mappings {
    device_name = "/dev/xvda" # Adjusted to the common root device name for Linux AMIs

    ebs {
      volume_size           = 30    # Disk size specified here
      volume_type           = "gp3" # Example volume type, adjust as necessary
      delete_on_termination = true
    }
  }

  # Additional tags for the launch template
  tags = {
    "Name"                                      = "${var.cluster_name}-eks-node-group"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }

  # Ensure the launch template is created before destroying the old one
  lifecycle {
    create_before_destroy = true
  }
}

############################################################################################################
# SSM variables
# - Uploads outputs to SSM Parameter store
############################################################################################################

# Upload Launch Template ID to SSM Parameter store
resource "aws_ssm_parameter" "nodes_lt_id" {
  name        = "/${var.environment}-iac/launch_templates/nodes_lt_id"
  description = "Nodes launch template ID"
  type        = "String"
  value       = aws_launch_template.eks_node_group.id

  tags = {
    Name = "${var.cluster_name}-launchtemplate-id"
  }
}
