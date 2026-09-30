# Security policy

Do not open a public issue with credentials or a vulnerability that could expose users. Use GitHub's private vulnerability reporting if enabled on this repository; otherwise contact the maintainers privately through their public GitHub profiles. Include impact, reproduction and affected files. Do not send live secrets. If a secret was committed, revoke it at the provider first; removing the Git commit alone does not make it safe.

All examples use placeholder values. Terraform state, plan files and AWS profiles must stay outside Git. Prefer federated temporary credentials and least privilege. Do not point exercises at production accounts.
