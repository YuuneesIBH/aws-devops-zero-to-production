# 7. Compute, storage and databases

EC2 is a virtual machine. An AMI supplies its starting disk image; instance type sets CPU, memory and network capacity. User data can bootstrap a host but should not carry secrets. Assign an IAM role through an instance profile instead of placing keys on disk. EBS is block storage attached to instances; snapshots support recovery. Auto Scaling Groups replace unhealthy instances and adjust desired capacity; load balancers distribute requests across healthy targets. Spot capacity can be interrupted; commitment discounts trade flexibility for lower rates.

Block storage exposes disk-like volumes. Object storage, such as S3, stores objects by key and serves them via APIs. File storage, such as EFS, exposes shared filesystem semantics. S3 versioning helps recover overwritten objects; lifecycle rules change storage tier or expiration. Keep public access blocked unless a reviewed use case requires it. A presigned URL grants time-limited access to a specific object operation. Encryption and bucket policy are separate controls.

A relational database stores tables and supports transactions. Indexes speed selected reads at write and storage cost. A connection pool reuses connections; too many clients can exhaust database capacity. PostgreSQL and MySQL commonly require TCP, authentication and optional or required TLS according to configuration. RDS manages parts of provisioning and backups, but you own schema, users, query behavior and access. Multi-AZ is for availability; read replicas serve read scaling and may lag. Snapshots and automated backups need restore tests. Aurora is an AWS-managed relational engine family. Redshift is a data warehouse for analytical workloads, not a drop-in transactional DB.

## Database connection triage

Resolve endpoint, test TCP port from the *application environment*, check RDS status and SG rules, then TLS and authentication. `nc -vz HOST 5432` proves only TCP connectivity. An SQL query and application log establish higher-layer health. Never log passwords or paste connection strings containing secrets into tickets.

## Knowledge check

Why is an EBS volume not equivalent to S3? Why might a healthy RDS instance still reject an application? What changes when a read replica lags?

Further reading: [EC2 user guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html), [S3 user guide](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html), [RDS user guide](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Welcome.html).

Continue with [compute and storage](services/compute-storage.md) and [RDS PostgreSQL](services/rds-data.md).
