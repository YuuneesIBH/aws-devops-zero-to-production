# High CPU

**Symptoms:** sustained CPU saturation, rising request latency, queue depth or throttling. **Impact:** slow requests and timeouts; a high percentage alone does not prove user impact.

## Immediate checks

Confirm affected service, time range and user-facing latency/error rate. Compare CPU **usage** with CPU **request/limit** and node pressure. Check whether load, a rollout or one tenant/query changed at the same time.

```sh
kubectl top pods -n NAMESPACE --containers
kubectl top nodes
kubectl describe pod POD -n NAMESPACE
kubectl rollout history deployment/DEPLOYMENT -n NAMESPACE
```

For an EC2 process, inspect `top`, `ps -eo pid,pcpu,pmem,comm --sort=-pcpu | head`, CloudWatch CPU and application logs. Use the right host and time window.

## Causes and mitigation

Possible causes: real demand, hot loop, expensive query, excessive retries, low CPU limit, uneven traffic or noisy neighbor. If user impact is real, stop a known bad rollout, throttle the expensive work or scale within measured capacity and quota. A higher CPU limit does not fix inefficient code or a slow database. Verify p95 latency, error rate and saturation after the change.

**Long-term fixes:** profile the hot path, bound concurrency, use load tests and choose requests/limits from measurements. **Escalate** when saturation persists after safe mitigation, data writes back up or a dependency is the real bottleneck.
