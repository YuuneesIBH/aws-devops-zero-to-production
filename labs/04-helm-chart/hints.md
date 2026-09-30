# Hints

1. Template validation checks string structure; it does not query ECR.
2. Compare `helm get values` and `helm get manifest` with the intended ECR digest.
3. Pod events often include `manifest unknown`, authorization or timeout clues. These point to different causes.
4. The Deployment revision and Helm release revision are related but not identical objects.
