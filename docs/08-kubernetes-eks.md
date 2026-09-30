# 8. Kubernetes and EKS

Kubernetes stores desired state in an API and controllers repeatedly try to make observed state match it. The control plane includes API server, scheduler and controllers; etcd stores cluster state. Nodes run kubelet and a container runtime. A Pod is the smallest deployable unit; it can be replaced at any time. A Deployment manages ReplicaSets, which maintain Pod count. Labels and selectors connect a Service to Pods. A Service provides a stable virtual endpoint while Pod IPs change.

Readiness says a Pod may receive traffic; liveness says a container should be restarted. Startup probes can protect slow-starting apps. CPU/memory requests influence scheduling; limits enforce ceilings and memory exhaustion can trigger OOMKilled. ConfigMaps hold non-secret configuration. Kubernetes Secrets are API objects, not automatically encrypted or safe for Git; use encryption and access control, and prefer an external secret source for production. Namespaces group names and policies but are not a full security boundary. RBAC controls API access. Ingress declares HTTP routing and needs a controller. Jobs run to completion, CronJobs schedule jobs, StatefulSets manage stable identities, DaemonSets run one Pod per matching node, and PVCs request persistent storage.

For local practice, apply [example manifests](../kubernetes/README.md). Diagnose with `kubectl get pods -o wide`, `kubectl describe pod NAME`, `kubectl logs NAME`, `kubectl get endpointslices` and `kubectl rollout status deployment/demo-api`. A Service with zero endpoints commonly has a mismatched selector or unready Pods. A Pending Pod may lack resources, storage or suitable nodes. CrashLoopBackOff means repeated process failure; inspect previous logs and events.

EKS is managed Kubernetes control plane plus AWS integrations; you still configure networking, node capacity or Auto Mode behavior, IAM, add-ons, observability and workload security. Access entries are the modern EKS access path. EKS Pod Identity associates IAM roles with service accounts for supported setups; older clusters may use IRSA. ECR stores images. AWS Load Balancer integration exposes appropriate Services or Ingress resources. EKS, nodes, load balancers and NAT can all incur charges.

## Knowledge check

Why does increasing replicas not fix a bad image? How can a healthy Pod receive no traffic? Which component chooses a node? Why should a Pod use its own IAM role instead of node-wide permissions?

Further reading: [Kubernetes concepts](https://kubernetes.io/docs/concepts/), [EKS access](https://docs.aws.amazon.com/eks/latest/userguide/cluster-auth.html), [EKS Pod Identity](https://docs.aws.amazon.com/eks/latest/userguide/pod-identities.html).
