# Lab 4: inspect and break a Helm chart

**Difficulty:** intermediate. **Architecture:** local Helm renderer → Kubernetes YAML. **Cost:** no AWS resources for this exercise. **Prerequisites:** Helm 3 or 4 and familiarity with Deployment, Service, labels and selectors. Work from repository root.

## Objectives

Explain chart versus release, default versus overridden values, template rendering, schema validation and why a successful render is not a successful deployment.

## 1. Render defaults

```sh
helm lint platform/chart
helm template platform-api platform/chart --namespace platform > rendered.yaml
```

Read `rendered.yaml`. Find Deployment, ServiceAccount, Service, PodDisruptionBudget and the test hook Pod. Explain where `replicaCount`, image digest, Service port and probe path came from. Defaults contain fake identifiers; do not deploy them.

## 2. Override behavior

```sh
helm template platform-api platform/chart --namespace platform \
  --set service.type=ClusterIP \
  --set replicaCount=3 > clusterip.yaml
```

Compare output. Why does a ClusterIP Service omit NLB annotations and `loadBalancerClass`? Why is the Pod template otherwise the same? Use `helm show values platform/chart` to inspect defaults.

## 3. Cause a validation failure

```sh
helm template platform-api platform/chart --set-string image.digest=latest
```

Read the schema error. The image field requires `sha256:` plus 64 lowercase hexadecimal characters. This prevents a mutable tag from accidentally being passed as a digest. It does not prove that an image exists in ECR.

## 4. Trace release behavior

Read [problem](problem.md), then [hints](hints.md), then [solution](solution.md). Predict what a later `helm upgrade` would change and what `helm rollback` could restore. Distinguish release revision from chart version and image digest.

## Verify

You should be able to identify all rendered resources and explain every changed field between the default and ClusterIP render. `helm lint` checks chart structure and template/schema validity; Kubernetes API validation and live readiness require a cluster.

## Troubleshooting

Missing Helm binary: install from the [official guide](https://helm.sh/docs/intro/install/). A schema error identifies a wrong value type or format. A template error identifies a missing key or invalid Go template. If rendering succeeds but a cluster install fails, inspect `helm status`, Kubernetes events, RBAC and the underlying image/DB path.

## Security and cleanup

Never put real passwords in `values.yaml`, command-line flags or `rendered.yaml`; Helm stores release values/manifest in the cluster. Delete `rendered.yaml` and `clusterip.yaml` when done, or keep them outside Git. No AWS cleanup is needed because this lab renders locally. If you also install the chart in a disposable cluster, run `helm uninstall platform-api -n platform` and verify the Service and any NLB are gone.

## Knowledge check

1. Why is `helm template` not a deployment test?
2. Where does Helm store release history?
3. Why can rollback be unsafe after a DB schema change?
4. What would happen if CI and a human alternated between Helm and `kubectl apply` on the same Deployment?
