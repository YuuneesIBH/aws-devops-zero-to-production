output "vpc_id" {
  description = "Created VPC ID."
  value       = aws_vpc.lab.id
}

output "subnet_ids" {
  description = "Created subnet IDs."
  value       = aws_subnet.lab[*].id
}
