# Terraform Modules Repository

Welcome! 🚀 

This repository contains a collection of reusable Terraform modules for provisioning various infrastructure components on AWS.

🚧 *Currently, a work in progress* 🚧

## Modules

### `ecr`
Creates immutable ECR registries for storing container images.

### `eks_cluster`
Provisions an Amazon Elastic Kubernetes Service (EKS) cluster on AWS. It sets up the necessary infrastructure including security groups, IAM roles, launch templates, and other configurations to create a fully functional EKS cluster.

### `eks_autoscaler`
Installs and configures the Cluster Autoscaler for an AWS Elastic Kubernetes Service (EKS) cluster. The Cluster Autoscaler automatically adjusts the size of the EKS worker node Auto Scaling Group to maintain availability for your Kubernetes pods.

### `eks_lb_controller`
Installs and configures the AWS Load Balancer Controller for an AWS Elastic Kubernetes Service (EKS) cluster. The AWS Load Balancer Controller manages the lifecycle of Application Load Balancers (ALBs) and Network Load Balancers (NLBs) for services running on EKS.

### `eks_rbac`
Sets up Role-Based Access Control (RBAC) for an AWS Elastic Kubernetes Service (EKS) cluster. It creates IAM roles, policies, and attaches them to the necessary entities, as well as updates the aws-auth ConfigMap to grant permissions to users and groups.

### `eks_monitoring`
Sets up Grafana, Prometheus, Loki, and Promtail for a monitoring solution on an AWS Elastic Kubernetes Service (EKS) cluster.

### `eks_external_dns`
Takes care of external DNS management within an AWS Elastic Kubernetes Service (EKS) cluster. External DNS is a critical component for Kubernetes clusters, enabling automatic management of DNS records for Kubernetes services.

### `github`
Sets up a GitHub integration on AWS by creating an OpenID Connect (OIDC) provider, IAM role, and attaching policies for GitHub Actions.

### `network`
Provisions a customisable network infrastructure on AWS, including a Virtual Private Cloud (VPC), subnets (public and private), an Internet Gateway (IGW), NAT Gateway, route tables, and SSM parameter store uploads.

## Quality Assurance

All modules in this repository undergo security analysist testing and validation to ensure reliability and security.

- **tfsec:** Every pull request (PR) undergoes security scanning using [tfsec](https://github.com/tfsec/tfsec) to identify potential security vulnerabilities or misconfigurations.
- **tflint:** Each PR is also checked using [tflint](https://github.com/terraform-linters/tflint) to ensure best practices and adherence to Terraform coding standards.

These processes are triggered by a github action workflow!

## Semantic Versioning

This repo follows semantic versioning for module releases. Upon merging to the `main` branch, modules are tagged automatically with version numbers according to the changes made, ensuring clear versioning and easy tracking of updates.

Happy Terraforming! 🌍💻
