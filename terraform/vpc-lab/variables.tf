variable "aws_region" {
  description = "Region for this disposable VPC lab."
  type        = string
  default     = "eu-west-1"
}

variable "vpc_cidr" {
  description = "IPv4 range for the VPC."
  type        = string
  default     = "10.42.0.0/16"
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid CIDR block."
  }
}
