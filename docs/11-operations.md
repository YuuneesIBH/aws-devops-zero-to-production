# 11. Observe, secure and respond

Metrics summarize numerical behavior, logs record events and traces connect work across services. Start with user-visible signals: request rate, error rate, latency and saturation. A dashboard without an action threshold is not an alerting strategy. Define an SLI such as successful request fraction, set an SLO and page on sustained user impact or fast error-budget burn. CloudWatch handles AWS metrics/logs; Prometheus collects time series; Grafana visualizes and can alert. Avoid labels with unbounded cardinality, such as user IDs. Verify alert delivery and runbooks, not only rule syntax.

Defense in depth means narrowly scoped IAM, private data paths, TLS, patched images, secret rotation, logging and backups. CloudTrail records AWS API activity. KMS manages encryption keys and policy; Secrets Manager can store/rotate secrets; Systems Manager can support remote operations; ACM manages eligible certificates. None replaces an access review. DNS, certificate name, trust chain, expiry and TLS termination all need checking when HTTPS fails.

During an incident, assign an incident lead, state user impact and time, preserve evidence, mitigate the immediate harm and communicate factual updates. Record a timeline in UTC. Change one variable at a time where possible. Roll back or fail over if it reduces impact, then verify the user path. Afterward, write a blameless review with contributing conditions and owners for fixes. On-call runbooks should name escalation and stop conditions.

Cost is an operational signal. Check budgets, usage and tags; right-size after measuring. NAT gateways, EKS control plane, load balancers, storage and data transfer may bill while idle. Remove abandoned environments and verify deletion. Multi-AZ, replicas and VPN increase resilience or connectivity but also complexity and cost; choose them from requirements rather than fashion.

## Knowledge check

Why does a healthy CPU metric not prove users can log in? What distinguishes a symptom alert from a cause dashboard? What must be verified after rollback?

Further reading: [AWS Well-Architected](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html), [Prometheus alerting](https://prometheus.io/docs/practices/alerting/), [Grafana alerting](https://grafana.com/docs/grafana/latest/alerting/).

Continue with [CloudWatch, CloudTrail and production signals](services/observability-operations.md).
