# Problem: chart renders, Pod cannot start

The chart passes `helm lint` and `helm template`. After install, the Deployment has no ready Pods and `kubectl describe pod` reports an image pull error. The current values specify an image digest that does not exist in ECR.

Without changing IAM permissions, identify which checks distinguish a nonexistent digest from blocked ECR network access. Write down what `helm rollback` changes, what it cannot change and how you would verify the user path after mitigation.
