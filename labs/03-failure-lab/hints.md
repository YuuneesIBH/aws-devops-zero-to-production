# Hints

1. A Service selects Pods by labels; names do not need to match.
2. Compare the Service `spec.selector` with Pod `metadata.labels`.
3. A matching Pod still needs to be ready to receive normal traffic.
