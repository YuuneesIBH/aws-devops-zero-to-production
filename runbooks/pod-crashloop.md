# Pod CrashLoopBackOff

**Symptoms:** restart count rises; Pod alternates between running and waiting. **Impact:** reduced capacity or outage if healthy replicas cannot serve.

**Immediate checks:** `kubectl get pods -n NAMESPACE`; `kubectl describe pod POD -n NAMESPACE`; `kubectl logs POD -n NAMESPACE --previous`. Check recent rollout, exit code, OOMKilled reason, probes, environment and mounted configuration. Avoid displaying Secret values.

**Possible causes:** application exception, missing config, bad dependency, OOM, overly aggressive liveness probe. **Mitigation:** stop rollout and restore a known healthy revision if data compatibility allows; scale healthy replicas if capacity permits. Verify readiness and a user request after change.

**Long-term fixes:** startup tests, resource measurements, dependency handling and smoke checks. **Escalate** when all replicas fail, data safety is unclear or rollback cannot be verified.
