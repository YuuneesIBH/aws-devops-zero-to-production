# AWS service map: choose the right boundary

The platform uses several AWS services because each solves a different part of the path. A service name is not an architecture. Ask what contract it provides, which operations it removes, which responsibilities remain and where the failure boundary sits.

| Need | Service in this platform | Contract | Still your responsibility |
| --- | --- | --- | --- |
| Isolated IP network | VPC | Subnets, routes, gateways, filtering primitives | CIDR plan, exposure and hybrid routing |
| Kubernetes control plane and managed nodes | EKS Auto Mode | Managed control plane and node/load-balancer integrations | Workloads, access, health, costs, upgrades |
| Container artifact store | ECR | Registry API and repository controls | Image content, digest, vulnerability response |
| Relational SQL | RDS PostgreSQL | Managed DB instance operations | Schema, SQL users, queries, backup verification |
| Secret storage | Secrets Manager | Encrypted secret API and rotation integrations | Least privilege, rotation compatibility |
| Temporary permissions | IAM/STS | Policies, roles and role sessions | Trust scope, reviews, incident response |
| Transport entry | NLB | TCP/TLS forwarding to targets | Protocol design, target health, DDoS posture |
| Public name and certificate | Route 53/ACM | DNS records and eligible certificate lifecycle | Domain ownership, record correctness, TLS design |
| Metrics/notifications | CloudWatch/SNS | Metric storage, alarms and delivery | SLOs, recipients, validation and response |
| Audit of AWS APIs | CloudTrail | API event history/trails | Retention, analysis and alerting |
| Shared Terraform state | S3 | Durable object storage and versioning | IAM restrictions, recovery and lifecycle |

## EC2, EKS and managed compute

EC2 gives a virtual machine with an AMI, network interface, security groups and EBS volumes. You manage OS configuration, runtime and much of patching. An Auto Scaling Group can replace unhealthy instances and adjust capacity, but your launch template and app health criteria determine what “healthy” means. EKS adds the Kubernetes scheduler/controllers and a deployment API. EKS Auto Mode manages the node lifecycle; it does not make application configuration correct. For a small single-service product, ECS or managed application platforms may be simpler than Kubernetes. Choose Kubernetes when its workload model, ecosystem and platform needs justify its operations and cost.

## EBS, EFS and S3

EBS is block storage: a volume behaves like a disk attached to compatible compute and has AZ-related placement rules. EFS is a network filesystem that multiple clients can mount. S3 is object storage addressed by keys and APIs, not a POSIX filesystem. An S3 Terraform-state bucket benefits from versioning and blocked public access; state still needs IAM control and safe recovery. Use lifecycle rules intentionally; an early expiration of state versions can defeat recovery. A database backup in S3 is not the same as a queryable database or a tested restore.

## NLB versus ALB

An NLB routes transport connections and can terminate TLS with ACM. It is a good fit for the platform's one public service. An ALB understands HTTP and can route by host/path, redirect HTTP to HTTPS and apply web-layer features. Neither automatically secures a backend: target registration, health checks, security groups and application authentication still matter. The initial platform uses NLB through EKS Auto Mode Service; the capstone diagram shows ALB as an alternative target architecture. Do not confuse their annotations or controller requirements.

## Route 53, ACM and the timing problem

ACM can issue a public certificate after domain validation. Terraform creates DNS validation records in an existing public hosted zone. The NLB hostname exists only after Kubernetes creates the Service, so the repository's DNS helper publishes a CNAME *after* deployment. This ordering is why the Terraform state does not own the final application DNS record. A CNAME cannot be placed at a zone apex; use a subdomain. For an apex, plan an alias record and its target metadata deliberately. Certificate region and DNS name must match the listener and client request.

## VPN and hybrid networks

Site-to-Site VPN can connect an on-premises network to AWS over encrypted tunnels. It does not automatically solve overlapping CIDRs, route propagation, DNS forwarding or firewall rules. A private RDS endpoint stays private; hybrid clients need a routed private path and explicit authorization. Transit Gateway can simplify many-network topology, but adds routing domains, policy and charges. The starter platform has no VPN; adding one requires a concrete on-premises CIDR, gateway details and a review of route overlap.

## Service selection exercise

For each design below, name the service and the responsibility it leaves you:

1. Store immutable container images before an EKS rollout.
2. Give GitHub Actions temporary deployment credentials without a static AWS key.
3. Let a private Pod query a relational database.
4. Allow an office network to reach private AWS addresses.
5. Expose two HTTP apps by different hostnames on one public entry point.

Then follow the answer through [the deployable platform](../../platform/README.md): does it implement the service now, or is it a reasoned extension?

Official references: [AWS service overview](https://docs.aws.amazon.com/whitepapers/latest/aws-overview/amazon-web-services-cloud-platform.html), [EC2 concepts](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html), [S3 guide](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html), [Elastic Load Balancing](https://docs.aws.amazon.com/elasticloadbalancing/latest/userguide/what-is-load-balancing.html), [Site-to-Site VPN](https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html).
