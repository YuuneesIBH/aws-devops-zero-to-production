data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)
  vpc_cidr = "10.64.0.0/16"
  db_cidrs = [for i in range(2) : cidrsubnet(local.vpc_cidr, 8, i + 40)]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = var.name
  cidr = local.vpc_cidr
  azs  = local.azs

  public_subnets   = [for i in range(2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_subnets  = [for i in range(2) : cidrsubnet(local.vpc_cidr, 8, i + 20)]
  database_subnets = local.db_cidrs

  enable_nat_gateway                 = true
  single_nat_gateway                 = true
  enable_dns_hostnames               = true
  enable_dns_support                 = true
  create_database_subnet_route_table = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}
