# High memory

**Symptoms:** rising working set, frequent garbage collection, node memory pressure or OOM kills. **Impact:** latency, restarts and interrupted requests; buffered or cached memory may be reclaimable.

## Immediate checks

Compare current memory with requests/limits and with the same process before the last release. Check restart count, `OOMKilled` reason, node pressure and workload growth. Distinguish a process leak from an intentional cache or larger batch.

```sh
kubectl top pods -n NAMESPACE --containers
kubectl describe pod POD -n NAMESPACE
kubectl get events -n NAMESPACE --sort-by=.metadata.creationTimestamp
kubectl logs POD -n NAMESPACE --previous --tail=100
```

## Causes and mitigation

Possible causes: leak, unbounded queue/cache, oversized batch, changed traffic, low memory limit or node pressure. Reduce batch size or concurrency; roll back a known bad revision if data compatibility permits. Increase a limit only when node capacity and workload measurements support it. Verify memory settles and requests succeed, not merely that the Pod restarted.

**Long-term fixes:** heap profiling, bounded caches/queues, realistic limits and load tests. **Escalate** for sustained OOMs, node-wide pressure or evidence of dropped writes.
