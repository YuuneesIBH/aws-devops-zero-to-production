# VPN or hybrid connectivity failure

**Symptoms:** on-prem client cannot reach a cloud private IP, or a cloud connector cannot reach a customer source. **Impact:** ingestion or administration may stop while public services remain healthy.

## Immediate checks

Record source/destination IP, port, protocol, time and which side initiated traffic. Check tunnel state, route advertisements/static routes, return path, DNS resolution, firewall/security group/NACL and certificate/PSK lifecycle. Compare with a known working flow from the same network segment.

```sh
dig +short source.internal.example
traceroute DESTINATION_IP
nc -vz DESTINATION_IP PORT
```

These client commands identify symptoms, not every cloud hop: ICMP/traceroute can be blocked even when TCP works. Inspect the specific VPN product's tunnel logs and metrics; never paste pre-shared keys into tickets or shell history.

## Causes and mitigation

Possible causes: tunnel down, expired certificate, changed peer IP, route overlap, missing return route, DNS split-horizon mismatch, firewall change or MTU fragmentation. Restore a known-good route/tunnel setting through the network owner. Do not widen `0.0.0.0/0` access as a quick fix. Verify the intended application query across the link and check for packet loss.

**Long-term fixes:** tunnel monitoring, route ownership, change records and failover drills. **Escalate** to both network owners when traffic crosses administrative boundaries or route/peer changes affect multiple tenants.
