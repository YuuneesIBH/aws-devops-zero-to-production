"""Render the platform manifest without templating shell commands."""

import os
import pathlib
import re
import sys

root = pathlib.Path(__file__).resolve().parents[1]
template = (root / "kubernetes/app.yaml.tpl").read_text()
values = {
    "__IMAGE__": os.environ["IMAGE_URI"],
    "__REGION__": os.environ["AWS_REGION"],
    "__DB_HOST__": os.environ["DB_HOST"],
    "__SECRET_ARN__": os.environ["DB_SECRET_ARN"],
}
for key, value in values.items():
    if not re.fullmatch(r"[A-Za-z0-9_./:@-]+", value):
        raise SystemExit(f"Unsafe manifest value for {key}")
    template = template.replace(key, value)
certificate = os.environ.get("ACM_CERT_ARN", "")
if certificate:
    if not re.fullmatch(r"arn:aws[a-z-]*:acm:[a-z0-9-]+:[0-9]{12}:certificate/[A-Za-z0-9-]+", certificate):
        raise SystemExit("Invalid ACM_CERT_ARN")
    template = template.replace("__TLS_ANNOTATIONS__", "    service.beta.kubernetes.io/aws-load-balancer-ssl-cert: " + certificate + "\n    service.beta.kubernetes.io/aws-load-balancer-ssl-ports: \"443\"")
    template = template.replace("__SERVICE_PORT__", "443")
else:
    template = template.replace("__TLS_ANNOTATIONS__", "")
    template = template.replace("__SERVICE_PORT__", "80")
sys.stdout.write(template)
