# EKS Cluster Module

This module provisions an Amazon Elastic Kubernetes Service (EKS) cluster on AWS.

It sets up the necessary infrastructure including security groups, IAM roles, launch templates, and other configurations to create a fully functional EKS cluster.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Inputs](#inputs)
- [Outputs](#outputs)

## Prerequisites

- Terraform v1.5.0
- AWS provider v5.40.0
- HTTP provider ~> 2.0
- tls provider >= 4.0.5

## Module Structure

It consists of several files:

1. **0-versions.tf**: Specifies the required Terraform version and provider versions.
2. **1-security-groups.tf**: Defines security groups for the EKS cluster and managed nodes, along with their respective ingress and egress rules.
3. **2-launch-templates.tf**: Sets up launch templates for EC2 instances in the EKS node group.
4. **3-iam.tf**: Creates IAM roles for the EKS cluster and worker nodes, attaches policies, and configures permissions.
5. **4-cluster.tf**: Creates the EKS cluster, configures VPC settings, encryption, and public/private access.
6. **5-oidc.tf**: Sets up an OpenID Connect Provider for EKS to enable IAM Roles for Service Accounts (IRSA).
7. **6-nodes.tf**: Defines EKS managed node groups, including scaling configurations and launch templates.
8. **7-addons.tf**: Configures EKS add-ons such as VPC CNI plugin and other specified cluster add-ons.
9. **outputs.tf**: Specifies the outputs of the module, including essential information about the created resources.


### Inputs

| Name                      | Description                                                                                                           | Type            | Default       | Required |
|---------------------------|-----------------------------------------------------------------------------------------------------------------------|-----------------|---------------|----------|
| environment               | The environment                                                                                                       | string          |               | yes      |
| cluster_name              | The name of the EKS cluster                                                                                           | string          |               | yes      |
| vpc_id                    | The ID of the VPC where the EKS cluster resides                                                                       | string          |               | yes      |
| node_iam_policies         | List of IAM Policies to attach to EKS-managed nodes.                                                                  | map(any)        |               | no       |
| eks_version               | Name of the cluster                                                                                                   | string          | "1.29"        | no       |
| whitelist_ips             | A list of CIDR ranges that can access the API externally                                                              | list(string)    | []            | no       |
| whitelist_workstation_ip  | Will whitelist the IP of your personal workstation allowing access to the Kube API                                    | bool            | true          | no       |
| private_subnets           | Private Subnet IDs for the EKS cluster                                                                                | list(string)    |               | yes      |
| public_subnets            | Public Subnet IDs for the EKS cluster                                                                                 | list(string)    |               | yes      |
| enable_irsa               | Determines whether to create an OpenID Connect Provider for EKS to enable IRSA                                        | bool            | true          | no       |
| node_groups               | Map of maps specifying managed node groups                                                                            | map(object)     |               | no       |
| default_ami_type          | The type of AMI to use for the node group. Valid values: AL2_x86_64, AL2_x86_64_GPU                                  | string          | "AL2_x86_64" | no       |
| cluster_addons            | List of strings specifying cluster addons                                                                             | list(string)    |               | no       |

### Outputs

| Name                                | Description                                               |
|-------------------------------------|-----------------------------------------------------------|
| control_plane_security_group_id     | ID of the security group for the EKS cluster control plane |
| worker_nodes_security_group_id      | ID of the security group for worker nodes                 |
| nodes_launch_template               | The ID of the AWS Managed nodes launch template           |
| eks_role_arn                        | The arn of the EKS control plane role                     |
| nodes_role_arn                      | The arn of the EKS Nodes role                             |
| eks_secrets_encryption_key          | The KMS key ARN used to encrypt K8s secrets               |
| eks_name                            | The EKS cluster name                                      |
| eks_version                         | The kubernetes version used by EKS                        |
| eks_cluster_id                      | The EKS cluster ID                                        |
| eks_cluster_endpoint                | The EKS cluster endpoint                                  |
| eks_cluster_ca_certificate          | The base64 encoded certificate data required to communicate with the cluster |
| eks_cluster_oidc_issuer_url         | The URL for the OIDC issuer                               |
| openid_provider_arn                 | The OIDC ARN of the Cluster                               |
| openid_provider_id                  | The OIDC ID of the Cluster                                |
| openid_provider_url                 | The OIDC URL of the Cluster                               |


## Usage

```hcl
module "eks_cluster" {
  source        = "path/to/eks_cluster"
  environment   = "dev"
  cluster_name  = "my-eks-cluster"
  vpc_id        = "your-vpc-id"
  private_subnets = ["subnet-1", "subnet-2"]
  public_subnets  = ["subnet-3", "subnet-4"]
  node_groups = {
    "group1" = {
      name          = "group1"
      capacity_type = "ON_DEMAND"
      desired_size  = 2
      min_size      = 1
      max_size      = 3
      instance_types = ["t3.medium"]
    }
  }
}

