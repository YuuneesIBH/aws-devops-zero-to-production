# Solution

The Service selector asks for `app=wrong-api`; the Pod has `app=demo-api`. Kubernetes creates no usable endpoint for that Service. Restore `app: demo-api` in the Service selector and apply. `kubectl get endpointslices -n demo` should now show a ready address, and `curl` through port-forward should work. If not, inspect readiness and container logs. Prevent this defect through manifest review and a smoke test that queries the Service after rollout.
