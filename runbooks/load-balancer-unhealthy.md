# Load balancer targets unhealthy

**Symptoms:** public endpoint fails or NLB target group reports unhealthy targets. **Impact:** users may receive timeouts even while a Kubernetes Service exists.

## Immediate checks

```sh
kubectl get svc,pods,endpointslices -n NAMESPACE -o wide
kubectl describe svc SERVICE -n NAMESPACE
kubectl describe pod POD -n NAMESPACE
aws elbv2 describe-target-health --target-group-arn TARGET_GROUP_ARN
```

Trace listener → target group → target address/port → subnet route/security group/NACL → Pod readiness. Read target health reason codes and health-check protocol, port and path. EKS Auto Mode may create a **Network** Load Balancer; do not assume ALB HTTP routing or health-check behavior. An empty EndpointSlice points first to selector/readiness, not Route 53.

## Causes and mitigation

Possible causes: zero Ready Pods, wrong Service selector/targetPort, health-check mismatch, blocked traffic, unavailable node or missing subnet tags. Restore a known-good chart revision or correct a specific failing rule through review. Verify target health **and** an external request from a client network.

**Long-term fixes:** external probes, clear health endpoints and ownership of LB annotations. **Escalate** if all targets remain unhealthy or the cloud controller cannot reconcile the Service. See [AWS NLB troubleshooting](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-troubleshooting.html).
