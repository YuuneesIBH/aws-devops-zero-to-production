# Problem

The Deployment has a running Pod and direct Pod access works, but the Service has no endpoints. Reproduce by changing `spec.selector.app` in a copy of `kubernetes/demo.yaml` from `demo-api` to `wrong-api`, then apply that copy. Do not modify the original. Investigate with `kubectl get pods --show-labels -n demo`, `kubectl get svc demo-api -o yaml -n demo`, `kubectl get endpointslices -n demo` and `kubectl describe pod -n demo POD`. Write down expected versus observed labels and readiness.
