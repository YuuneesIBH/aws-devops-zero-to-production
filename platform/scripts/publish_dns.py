"""Point an existing public Route 53 subdomain at the created NLB."""

import json
import os
import subprocess

import boto3

domain = os.environ["DOMAIN_NAME"].rstrip(".")
zone_id = os.environ["ROUTE53_ZONE_ID"]
service = json.loads(
    subprocess.check_output(
        ["kubectl", "get", "service", "platform-api", "-n", "platform", "-o", "json"],
        text=True,
    )
)
ingress = service["status"]["loadBalancer"]["ingress"]
if not ingress or "hostname" not in ingress[0]:
    raise SystemExit("Load balancer hostname not ready")
hostname = ingress[0]["hostname"]
if not hostname.endswith("elb.amazonaws.com"):
    raise SystemExit("Unexpected load balancer hostname")

boto3.client("route53").change_resource_record_sets(
    HostedZoneId=zone_id,
    ChangeBatch={
        "Comment": "AWS DevOps platform API",
        "Changes": [
            {
                "Action": "UPSERT",
                "ResourceRecordSet": {
                    "Name": domain,
                    "Type": "CNAME",
                    "TTL": 60,
                    "ResourceRecords": [{"Value": hostname}],
                },
            }
        ],
    },
)
print(f"Created CNAME {domain} -> {hostname}")
