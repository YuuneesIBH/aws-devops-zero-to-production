# Preparing for a data-platform DevOps role

This is a generic study plan for operating a cloud data platform, not a description of any company's private infrastructure. A platform may combine Kubernetes services, SQL query engines, connectors, warehouses and on-prem connectivity. Confirm the actual deployment, team responsibilities and incident process with your manager. Do not infer a specific cloud service from a product feature.

The [platform project](../platform/README.md) covers an AWS application path. This guide adds the **data-platform operating model** and a way to measure readiness. Reading all chapters is not a pass. The pass is doing the tasks below, explaining the evidence and recovering safely when something breaks.

## 1. Trace four real user paths

Draw these paths on paper. For each arrow, name the caller, destination, authentication, network boundary, timeout, log/metric, failure symptom and rollback owner.

| Path | Minimum trace |
| --- | --- |
| User opens the product | DNS → TLS/load balancer → frontend/API → identity check → metadata/data service → response |
| Customer source sync | Source API/database → connector → pagination/change capture → job state/checkpoint → staging/warehouse table → freshness check |
| Federated SQL query | User/API → query authorization → Trino coordinator → connector/catalog → remote source or warehouse → result; consider queuing, memory and source rate limits |
| On-prem source | Customer network/agent or tunnel → authenticated link → connector → ingestion; consider DNS, routing, certificate and one-way firewall constraints |

The actual internal path may differ. Ask for architecture diagrams and compare them with these hypotheses. Separate **control plane** (configuration, tenant permissions, schedules) from **data plane** (queries, rows, writeback) when you investigate access or outages.

## 2. Skills and evidence

| Skill | Practice | Evidence you can show |
| --- | --- | --- |
| Linux/networking | Resolve a service name, test TCP and TLS, inspect listening ports and process logs | A short diagnosis that identifies DNS, routing, TLS or application failure without guessing |
| AWS/IAM | Trace a GitHub OIDC role to ECR/EKS and a Pod Identity role to one secret | Explain both the allowed API and the exact trust principal; no static keys |
| Terraform | Read a plan for destructive replacements, remote state and lock behavior | Identify blast radius, state location, recovery and who approves apply |
| Kubernetes/Helm | Render chart, inspect rollout/events/endpoints, test revision and rollback | An image digest reaches ready Pods; a failing release is diagnosed and safely reverted |
| PostgreSQL/SQL | Explain roles, transactions, indexes, connection count and backup restore | Read-only query plan, least-privilege role proposal and restore checklist |
| Data pipelines | Model initial sync, incremental sync, retries, upsert, deletion and checkpoint | Re-running a failed batch produces the same target state without duplicate records |
| Trino | Explain coordinator/workers, catalog/connector, query stages and remote pushdown | Locate whether a slow query is waiting, resource-bound or blocked by the source |
| Reliability | Pick user-facing signals, alert threshold, runbook and rollback | One drill with timeline, evidence, mitigation and follow-up |
| Security | Map tenant boundary, secret access, audit trail and data retention | State what a compromised Pod can reach and how to revoke its access |

## 3. Deep dive: connector and pipeline operations

An ingestion job is more than a scheduled API call. First run may need a full snapshot. Later runs need an incremental marker: cursor, monotonically increasing ID, updated timestamp or source change stream. A timestamp alone can miss late-arriving updates or tied timestamps; use a stable ordering pair such as `(updated_at, id)` where the source supports it, overlap windows plus deduplication, or a source-specific cursor. Do not advance a checkpoint until the target write is durable. If source and target cannot share a transaction, retry safely with idempotent upsert keys. Decide explicitly how source deletions are detected: delete events, tombstones or periodic reconciliation.

Operational questions: Are API tokens valid? Is the source rate-limiting? Did a schema or permission change break extraction? Is the worker healthy but the source unreachable? Are retries bounded with backoff and jitter? Which records failed, and can they be replayed without overwriting newer data? Monitor **last successful sync**, records read/written/rejected, lag, error classes and per-tenant backlog. A green Kubernetes Pod does not prove fresh customer data.

These are general operating patterns. The exact connector contract, checkpoint semantics and writeback guarantees depend on the platform and source. Use the organization's internal runbooks for live changes.

## 4. Deep dive: Trino and query operations

A federated query can be slow even when Trino Pods are healthy. The coordinator parses and plans SQL; workers execute distributed stages. A catalog/connector talks to a source. Performance depends on filters and projections pushed to the source, data transferred, joins, skew, memory, concurrent workload and source behavior. A remote SaaS API may have very different latency and quotas from a warehouse table. An `EXPLAIN` plan and query ID are evidence; an arbitrary increase in worker count is not a diagnosis.

For a slow query: capture query ID and time range; check queued versus running time; inspect failed stage and memory/spill; compare source latency and rate-limit responses; inspect whether filtering was pushed down; check recent catalog/schema or release changes. Scope mitigation to the affected tenant/query where possible. Retrying a writeback query can duplicate external side effects unless its operation has an idempotency key or verified status.

Study the [Trino concepts](https://trino.io/docs/current/overview/concepts.html) and [EXPLAIN](https://trino.io/docs/current/sql/explain.html) documentation. Check the version actually deployed before applying a tuning recommendation.

## 5. Deep dive: multi-tenant reliability and security

For every service, ask which identity selects the tenant and where authorization is enforced. Kubernetes namespaces and network policies can constrain workloads but do not replace application-level row/tenant authorization. A connector credential must be scoped to one tenant/source as far as the upstream system permits. Secret rotation must include a tested failure path and revocation. Audit logs should answer who initiated a query, sync or writeback and which tenant/data source it affected, without recording secret values or sensitive rows.

Separate three promises: service availability, data freshness and correct results. A 200 response from an API proves neither that a pipeline ran nor that the warehouse reflects source deletions. Define SLOs for user-facing requests **and** data freshness where the product needs them. Test backups by restoring and validating data, permissions and application compatibility. Think through region failure, cloud-provider dependency and on-prem tunnel outage with an agreed recovery objective.

## 6. Four-week preparation path

This is a suggested sequence, not a guarantee of job readiness. Spend time on a step until you can show its evidence without following the answer text.

1. **Week 1 — base path:** finish foundations, IAM and VPC guides. Use the local API lab. Draw all four paths above. Diagnose a deliberately wrong DNS name, refused TCP connection and failed TLS name check.
2. **Week 2 — delivery path:** finish EKS, Helm and Terraform guides. Render the platform chart with two sets of values. Break one image digest in a disposable cluster, inspect events, fix it and explain rollback. Read the GitHub OIDC trust policy and identify its allowed repository/branch.
3. **Week 3 — data path:** work through SQL/PostgreSQL basics, connector checkpointing and Trino query plans. Complete the [data-platform incident lab](../labs/05-data-platform-incident/README.md). Explain why a healthy API may show stale data.
4. **Week 4 — operations:** run a full disposable AWS deployment if you have an approved account and budget. Verify an external request, trigger a safe failure, restore service and destroy all resources. If no AWS account is available, inspect plans and use local Kubernetes/Helm for the workload exercise. Write a one-page incident timeline and a first-week question list.

## 7. Readiness gate

Mark each item **done only with evidence**. If you cannot do it yet, that is a study target, not a personal verdict.

- [ ] Draw a request from DNS to Pod to database and locate a break using commands and logs.
- [ ] Explain a Terraform plan's destructive changes, state location and rollback limits.
- [ ] Deploy a Helm revision to a disposable environment and recover a failed rollout.
- [ ] Explain why a Pod can be healthy while a tenant's data is stale.
- [ ] Design an incremental sync that survives retries, duplicate events and source schema drift.
- [ ] Read a Trino query plan and distinguish waiting, compute pressure and slow source access.
- [ ] Propose an alert and runbook for data freshness and for API availability.
- [ ] Describe a least-privilege role, secret rotation and a tested restore path.
- [ ] State what you **do not know** about the organization's private stack and ask for the right internal diagram/runbook before changing production.

Passing this gate means you are prepared to contribute under the team's normal review and change process. Production ownership also requires organization-specific access, architecture, controls and supervised incident experience.

## 8. First-week questions for the team

Ask which cloud accounts/regions and Kubernetes distributions they use; how environments and tenant isolation work; where Helm/Terraform or other IaC lives; who owns deploy and rollback; where alerts, query IDs, pipeline-run IDs and audit logs live; what the most common connector failures are; what the escalation path is; and which low-risk ticket you can own first. Request a walkthrough of one recent incident and one safe deploy. Never copy internal diagrams, credentials or customer data into this public repository.
