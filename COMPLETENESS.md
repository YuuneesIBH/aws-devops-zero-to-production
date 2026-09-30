# What this repository does and does not prove

This is an evolving DevOps handbook and a **static-validated example platform**. The title describes the learning destination, not a certification that the AWS deployment has run successfully or is safe for an arbitrary production account. Use this page before relying on the repository for training or live changes.

## Coverage against the original course goal

| Requirement | Present today | Remaining evidence or work |
| --- | --- | --- |
| Beginner path from Linux and networking through AWS, Docker, Kubernetes, Terraform and CI/CD | Ordered [chapters](README.md#start-here) and deeper service guides | More exercises with observable pass/fail outcomes; current chapters are concise in places |
| End-to-end AWS application | Terraform for VPC, EKS Auto Mode, RDS, ECR, IAM, optional TLS; app, chart and manual GitHub deployment | **No real AWS apply or external smoke test recorded**; region/account-specific integration unknown |
| Infrastructure validation | Terraform formatting/validation, locked providers, docs links and local API tests | A reviewed plan and actual create/deploy/rollback/destroy in a disposable AWS account |
| 18 progressively harder projects | Five labs plus a capstone design/platform path cover some themes | Most projects are not separate hands-on exercises with their own architecture, verification, troubleshooting, cost and cleanup |
| Deliberate failure labs | Image/Helm, a general failure lab and data-platform incident | Specific DNS, TLS, security-group, route, memory, secret, selector and drift failures need reproducible setups and expected evidence |
| Production runbooks | The 14 requested topics are indexed in [runbooks](runbooks/README.md) | Validate commands and mitigation paths during controlled drills; assign real ownership/escalation in a workplace |
| Cheatsheets, glossary and interview practice | Scattered summaries and knowledge checks | Dedicated quick references, linked glossary and scenario-based interview answers remain unwritten |
| Architecture diagrams | README, service guides and capstone include Mermaid diagrams | Several requested layer-specific diagrams and annotated failure paths remain absent |
| Production observability | RDS CloudWatch alarms/dashboard; Pod logs can be inspected | Application metrics, centralized logs, tracing, user-facing SLO alerts and alert-delivery drill |
| Security and reliability | OIDC, Pod Identity, private RDS, optional TLS, deletion protection | Least-privilege DB user, RDS certificate identity verification, rotation, restore drill, HA choices, network policy and image/dependency gates |

## Evidence ladder

1. **Explained:** a chapter states the concept and tradeoffs.
2. **Implemented:** configuration or code exists and is reviewable.
3. **Statically checked:** syntax/tests pass without cloud resources.
4. **Deployed:** a disposable account or local cluster created the actual resources.
5. **Operated:** an external request, failure drill, rollback, restore and cleanup were observed and documented.

The AWS platform is currently at **level 3**. The [roadmap](ROADMAP.md) tracks work needed to reach levels 4–5. No reader should infer that a passing GitHub Actions check means the platform has been deployed.

## Suggested next milestones

1. Run the complete platform lifecycle in a disposable AWS account with a budget, collect sanitized outputs, fix integration failures and prove cleanup.
2. Add application metrics/log collection and an external health/freshness check, then test alert delivery and a safe rollback.
3. Build the missing hands-on projects and failure labs with explicit verification and cleanup, instead of adding empty folders.
4. Add concise cheatsheets, glossary, interview scenarios and diagrams that refer back to working labs.

The implementation is useful for learning and review now. Live production use still requires requirements, change control, security review and account-specific validation.
