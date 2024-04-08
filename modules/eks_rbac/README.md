# EKS RBAC (Role-Based Access Control) Module

This module sets up Role-Based Access Control (RBAC) for an AWS Elastic Kubernetes Service (EKS) cluster. 

It creates IAM roles, policies, and attaches them to the necessary entities, as well as updates the aws-auth ConfigMap to grant permissions to users and groups.

## Prerequisites

- Terraform v1.5.0
- AWS provider v5.40.0
- Kubernetes provider v2.26.0
- Helm provider v2.9.x

## Module Structure

It consists of several files:
- **0-versions.tf**: Defines the required Terraform providers and their versions.
- **1-rbac.tf**: Contains Terraform configurations to set up RBAC for the EKS cluster, including IAM roles, policies, IAM group, and aws-auth ConfigMap update.
- **variables.tf**: Defines input variables for the module, including the EKS cluster name and the ARN of the EKS Nodes Role.

## Inputs

| Name              | Description                                    | Type     | Default |
| ----------------- | ---------------------------------------------- | -------- | ------- |
| `cluster_name`    | The name of the EKS cluster                    | `string` |         |
| `node_role_arn`   | The ARN of the EKS Nodes Role                  | `string` |         |

## Usage

```hcl
module "eks_rbac" {
  source = "./modules/aws/eks_rbac"

  cluster_name   = "my-cluster"
  node_role_arn  = "arn:aws:iam::123456789012:role/eks-node-role"
}