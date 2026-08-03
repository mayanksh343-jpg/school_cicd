terraform {
  required_providers {
    //aws provider ha
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
// for local file creation ka liay
    local = {
      source = "hashicorp/local"
    }
  }
}

provider "aws" {
  region = var.aws_region
}