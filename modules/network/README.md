# Network Module for AWS Infrastructure

This Terraform module provisions a customisable network infrastructure on AWS, including a Virtual Private Cloud (VPC), subnets (public and private), an Internet Gateway (IGW), NAT Gateway, route tables, and SSM parameter store uploads.

## Prerequisites

- Terraform >= v1.5.0
- AWS provider >= v5.40.0

## Module Structure

The module consists of several files:

- `0-versions.tf`: Specifies the Terraform version and required providers.
- `1-vpc.tf`: Creates the Virtual Private Cloud (VPC) with DNS enabled.
- `2-igw.tf`: Creates the Internet Gateway (IGW) for public subnet internet access.
- `3-subnets.tf`: Defines private and public subnets within the VPC.
- `4-nat.tf`: Sets up the NAT Gateway for private subnet outbound internet access.
- `5-routes.tf`: Configures route tables for private and public subnets.
- `6-ssm.tf`: Uploads VPC and subnet information to AWS Systems Manager Parameter Store.
- `variables.tf`: Declares input variables used in the module.
- `outputs.tf`: Defines outputs including VPC ID, subnet CIDR blocks, and route table IDs.

## Module Variables

| Name                             | Description                                                          | Type          | Default       |
| -------------------------------- | -------------------------------------------------------------------- | ------------- | ------------- |
| `environment`                    | Environment deploying to.                                           | `string`      |               |
| `eks_subnets`                    | Create EKS-specific subnets and append Kubernetes tags to resources.| `bool`        | `true`        |
| `cluster_name`                   | Name of the EKS Cluster.                                            | `string`      |               |
| `vpc_cidr`                       | The IPv4 CIDR block for the VPC.                                    | `string`      | `172.16.0.0/16` |
| `private_subnet_count`           | Number of Private subnets.                                          | `number`      | `3`           |
| `public_subnet_count`            | Number of Public subnets.                                           | `number`      | `3`           |
| `public_subnet_additional_bits`  | Additional bits with which to extend the prefix for public subnets.  | `number`      | `8`           |
| `private_subnet_additional_bits` | Additional bits with which to extend the prefix for private subnets. | `number`      | `8`           |
| `private_subnet_tags`            | Tags to add to all private subnets.                                 | `map(any)`    | `{}`          |
| `public_subnet_tags`             | Tags to add to all public subnets.                                  | `map(any)`    | `{}`          |

When `eks_subnets` is set to `true`, the module automatically adds Kubernetes-specific tags to the resources created within the subnets. 

These tags are essential for integrating with EKS clusters and facilitate cluster management tasks such as ingress routing, network policies, service discovery and autoscaling.

## Outputs

| Name                       | Description                          |
| -------------------------- | ------------------------------------ |
| `vpc_id`                   | ID of the created VPC.               |
| `private_subnet_cidrs`     | Computed private subnet CIDR blocks. |
| `public_subnet_cidrs`      | Computed public subnet CIDR blocks.  |
| `private_subnet_ids`       | IDs of the computed private subnets. |
| `public_subnet_ids`        | IDs of the computed public subnets.  |
| `aws_route_table_public`   | ID of the public route table.        |
| `aws_route_table_private`  | ID of the private route table.       |
| `nat_gateway_ipv4_address` | Public IP address of the NAT Gateway.|

## Usage

```hcl
module "network" {
  source = "./modules/network"

  environment                = "dev"
  eks_subnets                = true
  cluster_name               = "my-cluster"
  vpc_cidr                   = "172.16.0.0/16"
  private_subnet_count       = 3
  public_subnet_count        = 3
  public_subnet_additional_bits = 8
  private_subnet_additional_bits = 8
  private_subnet_tags        = {
                                Tier = "private"
                              }
  public_subnet_tags         = {
                                Tier = "public"
                              }
}
