# Solution

Inspect `kubectl describe pod` events, ECR `describe-images` for the exact digest, node pull role and NAT/VPC endpoint path. A missing digest should be replaced with a known existing immutable digest through a reviewed Helm upgrade. A timeout with a valid digest points toward network access, while authorization errors point toward pull permissions.

`helm rollback platform-api REVISION -n platform --wait` restores a prior chart/values release, including its prior image reference. It cannot restore a deleted ECR image, undo database migrations or repair network/IAM failures. Verify Pod readiness, Service endpoints and an external `/ready` request after rollback.
