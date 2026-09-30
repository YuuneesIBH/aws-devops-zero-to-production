# Platform API Helm chart

This chart owns the platform ServiceAccount, Deployment, Service and PodDisruptionBudget. The `test` hook starts a short-lived Pod that calls `/ready` through the Service. It expects the Terraform-created `platform` namespace, EKS Pod Identity association and RDS endpoint from [platform setup](../README.md).

Defaults contain `example.invalid` identifiers and a zero digest for **rendering only**. Supply real values before install. No DB password belongs in values: the chart passes a Secrets Manager ARN, and the Pod reads the secret with Pod Identity.

## Inspect locally without AWS

```sh
helm lint platform/chart
helm template platform-api platform/chart --namespace platform
helm template platform-api platform/chart --namespace platform \
  --set service.tls.enabled=true \
  --set-string service.tls.certificateArn=arn:aws:acm:eu-west-1:123456789012:certificate/example
```

Check that Service port changes from 80 to 443, certificate annotation appears, and Deployment still uses image digest and `/ready` probe. The [Helm lab](../../labs/04-helm-chart/README.md) walks through this.

## Deploy

The [GitHub workflow](../../.github/workflows/deploy-platform.yml) passes Terraform-derived identifiers and an immutable ECR image digest to `helm upgrade --install`. It waits for readiness, then runs `helm test`. For manual operations, use the same release name `platform-api`, namespace `platform` and real values. Changing the release name changes resource names, but the Terraform Pod Identity association still expects service account `platform-api`.

```sh
helm list -n platform
helm status platform-api -n platform
helm get values platform-api -n platform
helm get manifest platform-api -n platform
helm history platform-api -n platform
```

To return to a known revision, inspect history and database compatibility, then run `helm rollback platform-api REVISION -n platform --wait`. Check user traffic afterward. `helm uninstall platform-api -n platform` removes release-owned resources, including the Service; wait for the cloud NLB to disappear before Terraform destroy. Hook test Pods have an explicit deletion policy on success; inspect failed test Pods during troubleshooting.

See [the Helm deep dive](../../docs/services/helm-charts.md) for chart design, values, release state, hooks, CRDs, security and rollback limits.
