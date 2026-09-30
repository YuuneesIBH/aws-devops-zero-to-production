# IAM AccessDenied

**Symptoms:** AWS API responds with `AccessDenied` or `UnauthorizedOperation`. **Impact:** a workflow or workload cannot perform a required action.

**Immediate checks:** record exact action, resource ARN, region, time and principal; run `aws sts get-caller-identity` in the affected context. Check identity policy, resource policy, permission boundary, SCP, session policy and conditions; inspect CloudTrail when available.

**Possible causes:** wrong role/profile, missing allow, explicit deny, incorrect resource ARN or failed condition. **Mitigation:** correct the narrowest policy or role assumption and retest the one action. Do not add wildcard admin rights as a shortcut.

**Long-term fixes:** policy tests, Access Analyzer review and documented role ownership. **Escalate** if a production role is affected broadly or policy ownership is unclear.
