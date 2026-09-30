# Pod OOMKilled

**Symptoms:** container exits with reason `OOMKilled`, often code 137, then restarts. **Impact:** in-flight work can fail; repeated restarts reduce available replicas.

## Immediate checks

```sh
kubectl get pods -n NAMESPACE -o wide
kubectl describe pod POD -n NAMESPACE
kubectl logs POD -n NAMESPACE --previous --tail=100
kubectl top pod POD -n NAMESPACE --containers
kubectl describe node NODE
```

Confirm which container was killed and whether its own limit or node pressure was involved. Inspect request/limit, memory growth, traffic, batch size and last release. Exit 137 alone is not enough to prove the kernel killed a container for memory; use the reported reason and events.

## Causes and mitigation

Possible causes: leak, bursty workload, unbounded cache/batch or limit below measured peak. Roll back a known bad release if schema compatible; reduce work size or raise memory only after checking node capacity and budget. Keep at least one healthy replica during remediation. Verify restarts stop and user requests succeed.

**Long-term fixes:** bounded allocation, profiling, load tests and resource tuning. **Escalate** for node-wide pressure, repeated loss of work or no safe healthy revision.
