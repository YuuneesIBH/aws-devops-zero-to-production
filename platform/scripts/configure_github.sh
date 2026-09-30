#!/usr/bin/env bash
set -euo pipefail

repo="$(gh repo view --json nameWithOwner --jq .nameWithOwner)"
tf_dir="platform/terraform"
gh api -X PUT "repos/${repo}/environments/platform" >/dev/null

set_variable() {
  local name="$1" output="$2" value
  value="$(terraform -chdir="$tf_dir" output -raw "$output")"
  gh variable set "$name" --env platform --body "$value"
}

set_variable AWS_ROLE_ARN github_deploy_role_arn
set_variable AWS_REGION aws_region
set_variable CLUSTER_NAME cluster_name
set_variable ECR_REPOSITORY_URL ecr_repository_url
set_variable DB_HOST database_endpoint
set_variable DB_SECRET_ARN database_secret_arn
set_variable ACM_CERT_ARN acm_certificate_arn
echo "Configured GitHub environment 'platform' for ${repo}. Add required reviewers in GitHub settings before production use."
