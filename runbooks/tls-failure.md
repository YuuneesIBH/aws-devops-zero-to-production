# TLS failure

**Symptoms:** certificate name/expiry/chain error, handshake failure or HTTPS timeout. **Impact:** clients may refuse the connection; bypassing verification exposes traffic.

## Immediate checks

```sh
curl -vI https://api.example.com/health
openssl s_client -connect api.example.com:443 -servername api.example.com </dev/null
dig +short api.example.com
```

Check DNS target, listener protocol/port, presented certificate subject/SAN, issuer chain, validity dates and regional ACM certificate status. SNI (`-servername`) matters when several names share an endpoint. Determine whether TLS terminates at NLB/ALB or the Pod; test each hop separately. Do not put private keys or full credential dumps in tickets.

## Causes and mitigation

Possible causes: wrong certificate ARN/region, incomplete DNS validation, expired certificate, wrong hostname, missing listener or backend TLS mismatch. Restore a known-good listener/certificate through the owning deployment path. Never use `curl -k` as the recovery. Verify a normal client request with hostname verification enabled.

**Long-term fixes:** certificate expiry/renewal alarms and a tested replacement procedure. **Escalate** for widespread trust failure or suspected private-key compromise.
