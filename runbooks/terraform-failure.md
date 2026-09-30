# Terraform failure or drift

**Symptoms:** failed `plan`/`apply`, state lock, unexpected replacement or resource changed outside Terraform. **Impact:** provisioning can stall; a careless retry can replace live infrastructure.

## Immediate checks

```sh
terraform version
terraform validate
terraform plan
terraform plan -refresh-only
terraform state list
```

Confirm AWS account/region, backend workspace/key and identity before running commands. Read the **first provider error** and the resource address. Check whether another apply holds the lock; never force-unlock merely because a run is slow. Compare code, state and real resource. `plan -refresh-only` shows detected external changes without proposing infrastructure changes; do not automatically apply that state update.

## Causes and mitigation

Possible causes: missing IAM permission, API quota, wrong variable/region, provider-version change, stale lock after confirmed dead run, drift or an unsafe replacement. Stop before destructive changes. Fix the root cause in code/config, re-plan and get review. For partial apply, inspect which resources exist before retry. Never delete state to make errors disappear.

**Long-term fixes:** pinned providers, protected remote state, serialized applies and drift review. **Escalate** for state corruption, uncertain partial apply or replacement of database/network/cluster resources. See [HashiCorp refresh-only guidance](https://developer.hashicorp.com/terraform/tutorials/state/refresh).
