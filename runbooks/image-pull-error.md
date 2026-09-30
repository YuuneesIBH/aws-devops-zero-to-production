# Image pull error

**Symptoms:** `ImagePullBackOff`, `ErrImagePull` or Pods stuck before container start. **Impact:** rollout may stall; existing healthy Pods may continue serving.

## Immediate checks

```sh
kubectl describe pod POD -n NAMESPACE
kubectl get deployment DEPLOYMENT -n NAMESPACE -o jsonpath='{.spec.template.spec.containers[*].image}'
helm history RELEASE -n NAMESPACE
```

Read the exact event: `manifest unknown` suggests a missing tag/digest; `unauthorized` suggests credentials or node pull role; timeout suggests DNS, NAT/VPC endpoint or registry reachability. Check the image **digest**, region, repository and ECR image listing. In EKS, image pulling is a node capability; a Pod Identity role used by the running app does not fix pull authorization.

## Causes and mitigation

Restore a known existing immutable digest through a reviewed Helm upgrade or rollback. Do not change a tag in place to hide a missing artifact. If the registry is unreachable, test network and DNS from the node path before changing IAM. Verify new Pods become Ready and the external user path works.

**Long-term fixes:** build-before-deploy checks, digest retention for rollback and registry access monitoring. **Escalate** if no valid image is available or a region-wide registry/network issue is suspected.
