# 10. CI/CD and artifact flow

Continuous integration validates each change; delivery packages a release candidate; deployment changes the running environment. A useful path is source → tests → image build → immutable image digest in ECR → reviewed rollout to EKS → health checks → rollback if needed. Tags are human labels; digests identify exact image content. Keep build and deploy permissions separate. GitHub Actions should assume a narrowly scoped AWS role using OIDC, with `id-token: write` granted only to the job that needs it; do not store long-lived AWS keys as GitHub secrets.

The included workflow runs tests and docs checks locally in GitHub runners. It does not deploy, since a safe deployment requires the account, IAM trust policy, cluster access and environment protection to be configured. In a deployment workflow, scope the OIDC trust policy to repository and branch or environment, use protected environments, record the image digest, deploy with an explicit strategy and verify health before declaring success.

For a Kubernetes Deployment, `kubectl rollout status deployment/demo-api` waits for the new revision. `kubectl rollout undo deployment/demo-api` requests the prior template, but only after checking database migration compatibility and why the release failed. Rollback is a change requiring verification, not a substitute for diagnosis.

## Knowledge check

Why pin deployment to an image digest? Why should a pull request test job not have AWS deploy permissions? What failure can make rollback unsafe after a database schema migration?

Further reading: [GitHub OIDC with AWS](https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws), [Kubernetes deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/).

Continue with [Terraform and GitHub Actions in the platform](services/terraform-delivery.md).
