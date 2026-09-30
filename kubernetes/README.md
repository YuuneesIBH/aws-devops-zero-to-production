# Local Kubernetes example

**Difficulty:** intermediate. **Architecture:** Service → one API Deployment Pod. **Cost:** local cluster resources; no AWS charges. **Prerequisites:** running local Kubernetes cluster, kubectl, and a container image built from `labs/01-local-api` and made available to the cluster. Image loading differs by kind, minikube and Docker Desktop; follow that cluster's official instructions. The manifest uses `demo-api:local` with `imagePullPolicy: Never`, so remote image pull is intentionally disabled.

```sh
kubectl apply -f kubernetes/demo.yaml
kubectl rollout status deployment/demo-api -n demo
kubectl get pods,svc,endpointslices -n demo
kubectl port-forward -n demo svc/demo-api 8080:80
```

In another terminal, `curl http://127.0.0.1:8080/health`. The Service selector must match Pod labels; readiness must pass before traffic reaches it. If Pod shows `ErrImageNeverPull`, load the image into the cluster runtime. For debugging use `kubectl describe pod -n demo POD` and `kubectl logs -n demo POD`.

Cleanup: `kubectl delete -f kubernetes/demo.yaml`; verify `kubectl get all -n demo` returns no namespace. Cluster-specific image cleanup is separate. No Kubernetes Secret is committed.

Knowledge check: Why might a running Pod have no Service endpoint? Why does a local image need loading into some cluster runtimes?
