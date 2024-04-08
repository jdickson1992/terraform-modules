resource "aws_ecr_repository" "ecr" {
  count                = length(var.ecr_names)
  name                 = var.ecr_names[count.index] # Name of the repository
  image_tag_mutability = "IMMUTABLE"                  # Dont allow images in repository to be overwritten
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true # Scan every image pushed to this ECR for softeware vulnerabilities
  }
  encryption_configuration {
    encryption_type = "KMS"
  }
  tags = var.tags
}