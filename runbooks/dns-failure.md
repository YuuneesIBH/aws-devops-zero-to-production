# DNS failure

**Symptoms:** `NXDOMAIN`, wrong address, intermittent resolution or stale record. **Impact:** clients cannot find the service, or reach the wrong endpoint.

## Immediate checks

```sh
dig +short api.example.com A
dig +short api.example.com CNAME
dig +trace api.example.com
```

Compare an affected client, a public resolver and the authoritative zone. Identify whether the name is public or private, its record type/TTL, delegation and the current load balancer hostname. For in-cluster names, inspect `kubectl get svc,endpointslices -n NAMESPACE` and CoreDNS status; public Route 53 records do not repair Kubernetes service discovery.

## Causes and mitigation

Possible causes: missing/wrong record, broken delegation, private zone visibility, cached old value or unhealthy target despite correct DNS. Restore the last known-good record only after checking its target still exists. Wait for TTL/propagation; verify from multiple networks and complete an HTTPS request, not just `dig`.

**Long-term fixes:** managed DNS changes, validation before cutover and low-risk rollback records. **Escalate** for domain-wide delegation failure or impact to multiple critical services.
