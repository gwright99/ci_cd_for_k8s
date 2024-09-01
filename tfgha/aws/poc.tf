## ------------------------------------------------------------------------------------
## Provider & Backend
## ------------------------------------------------------------------------------------
terraform {
  required_version = ">= 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.12.0"
    }
  }

  backend "local" {
    path = "DONTDELETE/terraform.tfstate"
  }
}


provider "aws" {
  region     = "us-east-1"
  retry_mode = "adaptive"

  default_tags {
    tags = {
      Terraform                     = "true"
      Environment                   = "dev"
      CreatedBy                     = "graham"
      GHA                           = "true"
    }
  }
}

# Build VPC
resource "aws_vpc" "vpc" {
    cidr_block = "10.10.0.0/16"
    instance_tenancy = "default"
}

# VPC ONLY requires following permissions:
#  "ec2:CreateVpc",
#  "ec2:CreateTags",
#  "ec2:DescribeVpcAttribute"
#######