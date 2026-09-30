# 5. AWS account and IAM

An AWS account is a billing and isolation boundary. Secure its root user with MFA and reserve it for tasks that require root. For daily human access, prefer IAM Identity Center federation and temporary credentials. Set a budget and alerts before creating resources; verify the selected region. An ARN names a resource; tags help ownership and cost allocation. AWS CLI calls the same service APIs as the console. `aws sts get-caller-identity` shows which principal is active without displaying credentials. Profiles select configuration; never commit profile files or keys.

IAM evaluates a request from a principal for an action on a resource under conditions. Identity policies attach to users/groups/roles; resource policies attach to supported resources. A role has a trust policy describing who may assume it; STS issues temporary credentials after assumption. An EC2 instance profile is a container for a role assigned to an instance. Service control policies and permission boundaries constrain what can be granted; they do not grant permissions themselves. An explicit deny wins. AWS may also reject a request due to a missing allow, resource policy, boundary, SCP, session policy or condition.

Example: read objects from one bucket prefix. Replace placeholder bucket and path with resources you own.

```json
{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Action":["s3:GetObject"],"Resource":"arn:aws:s3:::example-owned-bucket/public-docs/*"}]}
```

`Action: "*"` and `Resource: "*"` permit too much if attached to a broad identity. Use IAM Access Analyzer and observed access to refine permissions. For `AccessDenied`, record principal, action, resource ARN, region and request context; then inspect applicable policy layers. Do not solve it by attaching AdministratorAccess.

## Safe account setup

1. Secure root and enable MFA.
2. Configure federated human access and a named administrative role.
3. Create budget alerts; read current pricing for the chosen region.
4. Configure AWS CLI via supported SSO/federation flow; verify `aws sts get-caller-identity`.
5. Create only lab resources in a dedicated account where possible.

## Knowledge check

How does a trust policy differ from a permission policy? Why does an allow sometimes still yield `AccessDenied`? Why are temporary workload credentials safer than stored access keys?

Further reading: [AWS IAM best practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html), [IAM policy evaluation](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_evaluation-logic.html).
