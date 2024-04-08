# EKS Load Balancer Controller Module

This module installs and configures the AWS Load Balancer Controller for an AWS Elastic Kubernetes Service (EKS) cluster. 

The AWS Load Balancer Controller manages the lifecycle of Application Load Balancers (ALBs) and Network Load Balancers (NLBs) for services running on EKS.

## Prerequisites

- Terraform v1.5.0
- AWS provider v5.40.0
- Kubernetes provider v2.26.0
- Helm provider v2.9.x

## Module Structure

It consists of several files:
- **0-versions.tf**: Defines the required Terraform providers and their versions.
- **1-helm-release.tf**: Contains Terraform configurations to deploy and configure the AWS Load Balancer Controller using Helm.

## Inputs

| Name           | Description                          | Type     | Default |
| -------------- | ------------------------------------ | -------- | ------- |
| `cluster_name` | The name of the EKS cluster         | `string` |         |

## Usage

```hcl
module "eks_lb_controller" {
  source = "./modules/aws/eks_lb_controller"

  cluster_name = "my-cluster"
}