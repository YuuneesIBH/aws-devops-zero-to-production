# AWS service deep dives

Start with the ordered [foundation chapters](../01-foundations.md). Then follow these guides in platform dependency order. Each guide points to the actual Terraform, workflow or Kubernetes files that implement the concept.

| Order | Guide | Question it answers |
| --- | --- | --- |
| 1 | [IAM, STS and identity](iam-sts-identity.md) | Which principal can call which API, and why? |
| 2 | [VPC traffic](vpc-traffic.md) | Which route and filter let a packet reach its target? |
| 3 | [Compute and storage](compute-storage.md) | What runs, persists and survives replacement? |
| 4 | [EKS workloads](eks-workloads.md) | How does an image become a ready public service? |
| 5 | [RDS data path](rds-data.md) | How does a Pod authenticate and query a private DB? |
| 6 | [Terraform and delivery](terraform-delivery.md) | How do reviewed changes become AWS resources and releases? |
| 7 | [DNS, TLS and NLB](dns-tls-load-balancing.md) | How does a browser reach the right Pod securely? |
| 8 | [Observability](observability-operations.md) | How do operators detect, localize and mitigate failure? |
| Reference | [AWS service map](aws-service-map.md) | Why use each service and what remains your job? |

After reading, work through the [deployable platform](../../platform/README.md) and explain every arrow in its architecture diagram before applying Terraform. The guides are deeper than the introductions; they still do not replace current AWS service documentation or a production architecture review for your specific account.
