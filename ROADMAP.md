# Roadmap

Status reflects reviewed, substantive material, not empty directories.

| Area | Status | Next work |
| --- | --- | --- |
| Computer, Linux, networking, Git and cloud mental models | Complete | More guided exercises |
| AWS service models: IAM, VPC, compute, storage, EKS, RDS, DNS/TLS | Complete | More hands-on service-specific labs and live validation |
| Docker, local Kubernetes and Helm chart fundamentals | Complete | Compose, persistent-volume and live Helm upgrade labs |
| Terraform VPC lab | Complete | Separate state bootstrap and private endpoints |
| CI/CD fundamentals and Helm-based OIDC deployment | Complete | Live deployment and rollback verification |
| Observability, security and incident basics | Complete | Application metrics, centralized logs, tracing and SLO alerts |
| EKS Auto Mode, RDS, ECR, NLB, optional TLS and OIDC deployment | In Progress | Validate full create → deploy → external request → rollback → destroy in a disposable AWS account; then harden and add ALB option |
| Database recovery and access | In Progress | Restore-test a backup/final snapshot, use a least-privilege app role, verify RDS TLS identity and handle credential rotation |
| Runtime reliability and security | In Progress | Add app metrics/log collection, SLO alerts, external smoke checks, image scanning gate and dependency updates; assess Multi-AZ, NAT per AZ, private/restricted EKS API and network policies |
| 18 progressive projects, failure labs and full runbook library | In Progress | Expand beyond included starter labs |
| VPN, cost optimization, interview guide and cheatsheets | Not Started | Detailed chapters and exercises |

“Complete” means useful introductory coverage, not exhaustive service mastery. Cloud deployments are intentionally not run by CI. Each new cloud lab must include cost, access, verification and destruction guidance.
