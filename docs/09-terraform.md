# 9. Terraform: desired infrastructure and state

Terraform reads configuration, asks providers for current objects, computes a plan and applies approved changes. State maps resource addresses to remote objects; it is not merely a cache and may include sensitive values. Review the plan before apply. Keep remote state access narrow, versioned and locked for teams. The S3 backend supports `use_lockfile = true`; DynamoDB locking is deprecated for new configurations. Bootstrap the state bucket outside the configuration using it. Do not put backend credentials in source or CLI arguments that end up in local files.

Modules package a coherent set of resources with inputs and outputs. Prefer clear module boundaries over a module for each resource. Pin Terraform and provider version ranges deliberately; update through reviewed pull requests and test plans. `terraform fmt`, `terraform validate`, `terraform plan` and `terraform apply` answer different questions. `validate` does not prove the AWS account permits creation. A drifted resource is remote reality different from configuration/state; investigate before reconciling.

The [VPC lab](../labs/02-terraform-vpc/README.md) creates only a VPC and two subnets. It deliberately does not call them public/private because no Internet route exists. Its local state is ignored by Git; production teams should use a protected remote backend. `terraform destroy` removes lab resources after review. Check for resources created outside Terraform separately.

## Knowledge check

Why can two engineers applying against the same state cause damage? What does `plan` show that `fmt` cannot? Why does a VPC subnet not become public merely because its name says `public`?

Further reading: [Terraform state](https://developer.hashicorp.com/terraform/language/state), [S3 backend](https://developer.hashicorp.com/terraform/language/backend/s3).

Continue with [Terraform and the release boundary](services/terraform-delivery.md).
