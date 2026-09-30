terraform {
  required_version = ">= 1.10, < 2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

variable "aws_region" { type = string }
variable "bucket_name" { type = string }

provider "aws" { region = var.aws_region }
