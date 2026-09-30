output "cluster_name" { value = module.eks.cluster_name }
output "aws_region" { value = var.aws_region }
output "ecr_repository_url" { value = aws_ecr_repository.api.repository_url }
output "github_deploy_role_arn" { value = aws_iam_role.github_deploy.arn }
output "database_endpoint" { value = aws_db_instance.database.address }
output "database_secret_arn" { value = aws_db_instance.database.master_user_secret[0].secret_arn }
output "vpc_id" { value = module.vpc.vpc_id }
output "acm_certificate_arn" { value = var.domain_name == "" ? "" : aws_acm_certificate_validation.api[0].certificate_arn }
output "domain_name" { value = var.domain_name }
output "alert_topic_arn" { value = aws_sns_topic.alerts.arn }
