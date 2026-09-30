# Contributing

Open an issue for a proposed chapter or defect. For a pull request, explain the learner's starting knowledge, expected outcome, commands tested, AWS charges, cleanup and official sources. Keep examples small and do not add credentials, Terraform state or real Kubernetes Secrets. Run `python3 scripts/check_docs.py`, `python3 -m unittest discover -s labs/01-local-api/tests`, `terraform fmt -check -recursive terraform` and `git diff --check` where tools exist. A reviewer must verify technical claims and instructions before merging.
