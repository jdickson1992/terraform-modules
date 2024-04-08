# EKS Autoscaler Module

This module installs and configures the Cluster Autoscaler for an AWS Elastic Kubernetes Service (EKS) cluster. 

The Cluster Autoscaler automatically adjusts the size of the EKS worker node Auto Scaling Group to maintain availability for your Kubernetes pods.

## Prerequisites

- Terraform v1.5.0
- AWS provider v5.40.0
- Kubernetes provider v2.26.0
- Helm provider v2.9.x

## Module Structure

It consists of several files:
- **0-versions.tf**: Defines the required Terraform providers and their versions.
- **1-autoscaler.tf**: Contains Terraform configurations to deploy and configure the Cluster Autoscaler.
- **variables.tf**: Defines input variables for the module, including the EKS cluster name, endpoint, cluster CA certificate, enabling/disabling the Cluster Autoscaler, OIDC provider ARN and URL, and Cluster Autoscaler Helm version.


## Inputs

| Name                              | Description                                      | Type     | Default |
| --------------------------------- | ------------------------------------------------ | -------- | ------- |
| `cluster_name`                    | The name of the EKS cluster                     | `string` |         |
| `cluster_endpoint`                | The EKS cluster endpoint                        | `string` |         |
| `cluster_ca_certificate`          | The EKS cluster CA certificate                   | `string` |         |
| `enable_cluster_autoscaler`       | Install cluster autoscaler                      | `bool`   | `true`  |
| `cluster_openid_provider_arn`     | The OIDC ARN of the Cluster                     | `string` |         |
| `cluster_openid_provider_url`     | The OIDC URL of the Cluster                     | `string` |         |
| `cluster_autoscaler_helm_version` | Cluster Autoscaler Helm version                  | `string` |         |


## Usage

```hcl
module "eks_autoscaler" {
  source = "./modules/aws/eks_autoscaler"
  cluster_name                    = "my-cluster"
  cluster_endpoint                = "https://cluster.endpoint"
  cluster_ca_certificate          = "-----BEGIN CERTIFICATE-----\n..." # module.eks.eks_cluster_ca_certificate
  enable_cluster_autoscaler       = true
  cluster_openid_provider_arn     = "arn:aws:eks:us-west-2:123456789012:oidc/id/abc123def456"
  cluster_openid_provider_url     = "https://oidc.eks.us-west-2.amazonaws.com/id/abc123def456"
  cluster_autoscaler_helm_version = "9.36.0"
}