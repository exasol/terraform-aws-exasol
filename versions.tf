
terraform {
  required_version = ">= 1.5.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.5.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
  }
}
