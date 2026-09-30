# Lab 2: VPC and subnets with Terraform

**Difficulty:** intermediate. **Architecture:** one VPC, two subnets in distinct AZs. No Internet gateway, NAT gateway or instances. **Cost:** VPC/subnets generally have no hourly charge, but account-specific pricing and future changes can differ; inspect current AWS pricing. **Prerequisites:** Terraform, AWS CLI, an AWS lab account, permissions for VPC/subnet creation and deletion, budget alerts.

1. Verify the principal: `aws sts get-caller-identity`. Confirm account and region before any apply.
2. From `terraform/vpc-lab`, run `terraform init`, `terraform fmt -check`, `terraform validate`, `terraform plan -out=lab.tfplan`.
3. Review planned IDs, CIDRs, region and account context. Then `terraform apply lab.tfplan`.
4. Verify in console or `aws ec2 describe-vpcs` and `aws ec2 describe-subnets` with your selected region.

No subnet is publicly reachable: neither has an Internet gateway route, and no workload exists. State remains local for teaching and is ignored by Git. Do not use local state for team infrastructure; follow [Terraform chapter](../../docs/09-terraform.md) for remote state and locking.

## Cleanup

Run `terraform destroy` in the same directory and approve only after reviewing the plan. Verify VPC/subnets are gone in the console. Investigate manual resources attached to the VPC if destroy fails. Do not delete state before confirming destruction.

## Debug

`AccessDenied` → identify the active principal and exact missing action. CIDR overlap → inspect existing VPC ranges. AZ capacity/availability → choose a different region/AZ combination. `terraform plan` network or provider failures → check local credentials, proxy and AWS service endpoint reachability.

## Knowledge check

What makes a subnet public? Why is a plan file sensitive? Why must destroy use the same state?
