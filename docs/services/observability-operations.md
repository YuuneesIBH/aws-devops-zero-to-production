# CloudWatch, CloudTrail and production signals

Read [operations basics](../11-operations.md) first. Observability is not a collection of charts. It is the ability to answer whether users are affected, where a request failed and what changed. This platform currently has RDS CloudWatch metrics/alarms, Kubernetes Pod logs and AWS API audit events where CloudTrail is enabled. Application-wide metrics, centralized Pod logs and traces remain [roadmap work](../../ROADMAP.md); do not mistake the current dashboard for complete production observability.

## 1. Three telemetry types

Metrics are aggregated numeric series such as request rate, p95 latency or RDS CPU. Logs are timestamped records of individual events. Traces connect spans across services for a request. Each has different cost and diagnostic value. A request ID in logs can link a failing browser response to Pod events and database calls; a metric reveals whether the problem is isolated or widespread. High-cardinality metric labels (user ID, request ID) can increase time-series volume dramatically. Keep those values in logs/traces instead.

The first signals should represent user experience: success rate, latency, traffic and saturation. Host CPU may explain a problem but cannot prove users can complete a transaction. A useful SLI is the fraction of eligible requests completed successfully within a latency threshold. An SLO states the target over a window. An error budget turns failures into a tradeoff between reliability and deployment speed. A page should correspond to action needed now; a dashboard can contain many non-paging diagnostic signals.

## 2. CloudWatch in the platform

[observability.tf](../../platform/terraform/observability.tf) defines alarms for RDS average CPU above 80% over 15 minutes and free storage below 2 GiB across two five-minute periods. It also defines a dashboard with CPU and connection count. These thresholds are examples. A small DB may require lower connection limits, and CPU may be high without user impact. Tune thresholds from measured workload and pair them with app error/latency signals.

The alarms send to an SNS topic. If `alert_email` is set, the recipient must confirm its SNS subscription; otherwise messages are not delivered. Test delivery through an approved procedure. CloudWatch alarm state `INSUFFICIENT_DATA` is not the same as healthy; check missing metrics, region and dimension values. `treat_missing_data = "missing"` was chosen to make gaps visible rather than automatically healthy.

CloudWatch dashboards, custom metrics, log ingestion/retention, alarms and SNS can each incur charges. Set retention policies and sampling according to operational needs. The platform does not yet export application logs centrally, so `kubectl logs` is not durable evidence after a Pod disappears unless another collector is configured.

## 3. CloudTrail is an audit trail, not an app log

CloudTrail records AWS API activity such as a role assuming permissions or an RDS configuration change. It does not record SQL queries inside PostgreSQL or HTTP requests to the API. A trail or event data store needs appropriate retention and scope. During an IAM incident, use principal ARN, event time, event name, resource and error code. Avoid publishing event payloads containing sensitive metadata. CloudTrail helps answer *who changed the control plane*; app logs help answer *what happened to a request*.

## 4. Incident triage order

1. State the symptom in user terms, start time, affected region/path and current severity.
2. Check the user path externally: DNS → TCP/TLS → NLB → Service endpoints → Pod readiness → RDS.
3. Correlate recent deployments, Terraform applies, secret rotations and AWS Health events with the timeline.
4. Choose a mitigation with bounded blast radius, such as rollback if schema-compatible, scaling if measured saturation, or correcting a known bad rule.
5. Verify the user path after mitigation. Keep timestamps, commands and outcomes in an incident log.

Do not immediately increase replicas for a database outage. All new Pods may fail readiness and add connection pressure. Do not restart every Pod for a DNS error before checking the DNS name and resolver.

## 5. Logs, metrics and alerts for each hop

| Hop | User-facing symptom | Useful evidence | Missing from starter stack |
| --- | --- | --- | --- |
| DNS/TLS | Name or certificate error | `dig`, `curl -v`, ACM/Route 53 status | External probe alert |
| NLB | Timeout or bad target health | Service events, target health | NLB access logs and alert |
| Kubernetes | 5xx/unready | Pod events, rollout, logs | Durable central Pod logs |
| Secret/IAM | `/ready` 503 | Pod log class, STS/CloudTrail | Structured app error metric |
| RDS | Timeout, auth, slow query | RDS events, metrics, DB logs | Query tracing and restore drills |

## 6. A small failure exercise

In a disposable environment, create an alert route that you can actually receive. Then simulate a benign application failure in a separate namespace rather than modifying RDS or production resources. Measure when the signal appears, how long delivery takes and whether the runbook leads to a useful first action. The result is a verification of the monitoring path, not just the alarm definition. Clean up the test workload and any temporary alarms afterward.

## Knowledge check

1. Why does CloudTrail not explain a slow SQL query?
2. Why can an alarm exist yet never notify a person?
3. What would you add to distinguish an app failure from a database failure at the SLO level?
4. Why is an `INSUFFICIENT_DATA` alarm state operationally important?

Official references: [CloudWatch concepts](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/cloudwatch_concepts.html), [CloudWatch alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html), [CloudTrail concepts](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-concepts.html), [Prometheus alerting practices](https://prometheus.io/docs/practices/alerting/).
