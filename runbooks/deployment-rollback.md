# Deployment rollback

**Symptoms:** error/latency increase after release; readiness or smoke checks fail. **Impact:** user traffic degraded.

**Immediate checks:** confirm release version, user impact, deployment events and whether schema or external API changes prevent rollback. `kubectl rollout history deployment/NAME -n NAMESPACE`; inspect Pod logs and dashboard.

**Mitigation:** with incident lead approval in your operating process, `kubectl rollout undo deployment/NAME -n NAMESPACE`; then `kubectl rollout status deployment/NAME -n NAMESPACE`. Verify a real user path and data behavior. If migration is incompatible, stop and follow a tested forward-fix or restore plan instead.

**Long-term fixes:** progressive rollout, predeployment compatibility checks, digest-based releases and rollback drills. **Escalate** if data consistency or recovery is uncertain.
