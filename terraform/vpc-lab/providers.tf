provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project   = "aws-devops-zero-to-production"
      ManagedBy = "terraform"
      Lab       = "vpc"
    }
  }
}
