resource "aws_security_group" "database" {
  name        = "${var.name}-database"
  description = "PostgreSQL from private EKS subnets"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = "${var.name}-database"
  }
}

resource "aws_vpc_security_group_ingress_rule" "database" {
  for_each          = toset(module.vpc.private_subnets_cidr_blocks)
  security_group_id = aws_security_group.database.id
  cidr_ipv4         = each.value
  from_port         = 5432
  to_port           = 5432
  ip_protocol       = "tcp"
  description       = "EKS private subnet PostgreSQL access"
}

resource "aws_db_subnet_group" "database" {
  name       = "${var.name}-database"
  subnet_ids = module.vpc.database_subnets
}

resource "aws_db_instance" "database" {
  identifier                  = var.name
  engine                      = "postgres"
  instance_class              = var.db_instance_class
  allocated_storage           = 20
  max_allocated_storage       = 100
  storage_encrypted           = true
  manage_master_user_password = true
  username                    = "platform_admin"
  db_name                     = "platform"
  db_subnet_group_name        = aws_db_subnet_group.database.name
  vpc_security_group_ids      = [aws_security_group.database.id]
  publicly_accessible         = false
  backup_retention_period     = 7
  deletion_protection         = var.deletion_protection
  skip_final_snapshot         = !var.deletion_protection
  final_snapshot_identifier   = var.deletion_protection ? "${var.name}-final" : null
  apply_immediately           = false
  auto_minor_version_upgrade  = true
}

resource "aws_ecr_repository" "api" {
  name                 = "${var.name}-api"
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  encryption_configuration {
    encryption_type = "AES256"
  }
  force_delete = false
}
