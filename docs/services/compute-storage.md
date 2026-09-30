# EC2, EBS, S3 and ECR: what persists, what scales

Read [compute and data overview](../07-compute-data.md) first. These services all store or run something, but their failure and ownership models differ. EC2 executes an operating system, EBS stores block data, S3 stores objects and ECR stores container image artifacts on top of registry APIs. Understanding the boundaries prevents common errors such as treating a container filesystem as durable storage.

## 1. EC2 lifecycle and the OS boundary

An EC2 instance starts from an AMI, an image containing an operating system and optional software. Instance type selects capacity characteristics such as vCPU, memory and networking. A launch template can define an AMI, instance type, IAM instance profile, user data and security groups. An Auto Scaling Group can maintain a desired count and replace unhealthy instances. That replacement destroys ephemeral instance-local state. The application must externalize durable data and treat bootstrapping as repeatable.

The instance has one or more network interfaces with private IPs and security groups. A public subnet route does not give an instance a public IP automatically. IMDS provides instance metadata and temporary IAM role credentials; protect access to it and prefer IMDSv2 where the service supports it. SSH keys grant OS access, while IAM roles grant AWS API permissions. These are different identity systems. Systems Manager Session Manager can reduce the need for inbound SSH if configured with the required agent, role and network path.

User data can initialize an instance, but it is not a secret vault. Avoid embedding database passwords or tokens. Bake repeatable software into an image or use a controlled bootstrap, and record what version was launched. During an incident, distinguish a process crash from instance failure, bad AMI, ASG replacement, network block and unavailable downstream service.

## 2. EBS: block storage follows placement rules

An EBS volume provides block storage to compatible EC2 workloads. Filesystems on it behave like local disk from the guest OS perspective, but the volume is a separate AWS resource with its own lifecycle, encryption, size and performance settings. EBS volumes are tied to an AZ; an instance in another AZ cannot simply attach the same volume in the ordinary case. Snapshots support point-in-time recovery to new volumes. A snapshot is not an application-consistent backup unless the application quiesces or coordinates writes appropriately.

If `df -h` says the filesystem is full, increasing an EBS volume may be only the first step: the partition and filesystem may also need expansion. If an instance is terminated, volume deletion depends on its block-device mapping. Always inspect the launch template or instance setting before assuming data survives.

## 3. S3: object semantics and state protection

S3 stores objects by key inside buckets. An object is read or replaced through an API; S3 is not a general shared POSIX filesystem. Bucket policies, IAM policies, block public access, encryption and versioning solve different problems. Block public access is a protective guardrail, not a complete least-privilege policy. Versioning preserves previous versions after replacement or deletion markers, but it increases retained storage. Lifecycle rules can transition or expire versions; applying them to a Terraform state bucket without a recovery plan can delete your safety net.

The platform's [state bootstrap](../../platform/state-bootstrap/main.tf) creates a versioned encrypted bucket and blocks public access. Terraform state may contain resource attributes or secrets; restrict the bucket to trusted operators/automation and audit access. S3 server-side encryption protects data at rest, but an authorized principal can still read plaintext through the API. Use distinct state keys and roles across environments to limit blast radius.

## 4. ECR: image registry, not runtime

ECR stores OCI-compatible images; it does not run them. The Docker build process creates layers from a Dockerfile. The tag is a repository pointer; the digest identifies content. The [deploy workflow](../../.github/workflows/deploy-platform.yml) pushes a unique tag and deploys its digest to Kubernetes. ECR scanning on push generates findings for review, but it cannot detect every application flaw or prove a build is reproducible. Rebuild when the base image changes even if your application source does not.

Private EKS nodes need a path to ECR APIs and image layers. The platform uses a NAT gateway. A stricter network design may use VPC endpoints for ECR and S3, with appropriate endpoint policies and DNS; evaluate cost and required services rather than assuming endpoints are free. ECR lifecycle policies can remove old images, but retain the digests needed for rollback. The platform repository sets `force_delete = false`, so Terraform destroy requires clearing images deliberately.

## 5. Compare failure domains

| Resource | If compute disappears | If AZ fails | Recovery tool |
| --- | --- | --- | --- |
| EC2 process/instance | Process or VM stops | VM may be unavailable | ASG replacement, AMI, external state |
| EBS volume | May remain or delete per mapping | Volume inaccessible from other AZ | Snapshot/new volume, app restore |
| S3 object | Independent of one EC2 instance | Regional service design | Version restore, replication if designed |
| ECR image | Existing Pods may continue; new pulls depend on registry/network | Region/service availability matters | Retained digest, alternate region strategy |

No single recovery tool covers the application. Restoring an EBS volume does not recreate IAM, DNS or a missing image. Use a recovery plan that identifies each dependency.

## Failure walk: Pod cannot start after a rollout

`kubectl describe pod` shows an image pull error. Confirm URI and digest exist in ECR. If they exist, check the node's pull role and private subnet path to ECR and S3. If the image pulls but the process crashes, inspect logs and filesystem permissions. If the app writes to its container layer, those writes disappear on Pod replacement; use a database, object store or PVC for durable data based on access pattern.

## Knowledge check

1. Why does ASG replacement not preserve process memory or container filesystem writes?
2. Why is an EBS snapshot not automatically an application-consistent backup?
3. Which controls protect S3 state against public reads, unauthorized reads and accidental overwrite?
4. Why must ECR retain older image digests during a rollback window?
5. Which problem does an image registry solve that a runtime does not?

Official references: [EC2 concepts](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html), [EBS concepts](https://docs.aws.amazon.com/ebs/latest/userguide/what-is-ebs.html), [S3 versioning](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Versioning.html), [ECR concepts](https://docs.aws.amazon.com/AmazonECR/latest/userguide/what-is-ecr.html).
