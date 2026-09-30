variable "name" {
  description = "Short lowercase platform name; unique within the AWS account."
  type        = string
  default     = "devops-platform"
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,24}$", var.name))
    error_message = "Use 3-25 lowercase letters, digits or hyphens, starting with a letter."
  }
}

variable "aws_region" {
  description = "AWS region supporting the selected EKS version and Auto Mode."
  type        = string
  default     = "eu-west-1"
}

variable "kubernetes_version" {
  description = "EKS version available in the selected region. Check before apply."
  type        = string
  default     = "1.33"
}

variable "github_repository" {
  description = "GitHub owner/repo allowed to deploy from main."
  type        = string
  validation {
    condition     = can(regex("^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$", var.github_repository))
    error_message = "Use owner/repo."
  }
}

variable "db_instance_class" {
  description = "RDS instance class; check regional availability and price."
  type        = string
  default     = "db.t4g.micro"
}

variable "deletion_protection" {
  description = "Enable for long-lived environments; disable only for disposable labs."
  type        = bool
  default     = true
}

variable "final_snapshot_identifier" {
  description = "Optional unique RDS snapshot name to retain on destroy; null skips the final snapshot. Set explicitly before destroy."
  type        = string
  default     = null
  validation {
    condition     = var.final_snapshot_identifier == null ? true : can(regex("^[a-zA-Z](?:[a-zA-Z0-9]|-(?:[a-zA-Z0-9]))*$", var.final_snapshot_identifier)) && length(var.final_snapshot_identifier) <= 255
    error_message = "Use 1-255 letters, digits or single hyphens; start with a letter and end with a letter or digit."
  }
}

variable "domain_name" {
  description = "Optional full hostname, e.g. api.example.com. Leave empty for HTTP-only lab."
  type        = string
  default     = ""
}

variable "route53_zone_id" {
  description = "Existing public hosted zone ID for domain_name validation."
  type        = string
  default     = ""
}

variable "alert_email" {
  description = "Optional email for RDS alarms. Recipient must confirm SNS subscription."
  type        = string
  default     = ""
}
