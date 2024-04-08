terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.40.0"
    }
    hashicorp-http = {
      source  = "hashicorp/http"
      version = "~> 2.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = ">= 4.0.5"
    }
  }
}