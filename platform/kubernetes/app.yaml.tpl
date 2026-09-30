apiVersion: v1
kind: ServiceAccount
metadata:
  name: platform-api
  namespace: platform
automountServiceAccountToken: false
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: platform-api
  namespace: platform
spec:
  replicas: 2
  revisionHistoryLimit: 5
  strategy:
    rollingUpdate:
      maxUnavailable: 0
      maxSurge: 1
  selector:
    matchLabels:
      app: platform-api
  template:
    metadata:
      labels:
        app: platform-api
    spec:
      serviceAccountName: platform-api
      automountServiceAccountToken: false
      terminationGracePeriodSeconds: 30
      containers:
        - name: api
          image: __IMAGE__
          ports:
            - containerPort: 8080
          env:
            - name: AWS_REGION
              value: __REGION__
            - name: DB_HOST
              value: __DB_HOST__
            - name: DB_SECRET_ARN
              value: __SECRET_ARN__
          readinessProbe:
            httpGet:
              path: /ready
              port: 8080
            periodSeconds: 10
            failureThreshold: 3
          livenessProbe:
            httpGet:
              path: /health
              port: 8080
            periodSeconds: 20
          startupProbe:
            httpGet:
              path: /health
              port: 8080
            periodSeconds: 5
            failureThreshold: 12
          resources:
            requests:
              cpu: 50m
              memory: 128Mi
            limits:
              memory: 512Mi
          securityContext:
            allowPrivilegeEscalation: false
            runAsNonRoot: true
            runAsUser: 65532
            readOnlyRootFilesystem: true
            capabilities:
              drop: ["ALL"]
            seccompProfile:
              type: RuntimeDefault
---
apiVersion: v1
kind: Service
metadata:
  name: platform-api
  namespace: platform
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
    service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: ip
__TLS_ANNOTATIONS__
spec:
  type: LoadBalancer
  loadBalancerClass: eks.amazonaws.com/nlb
  selector:
    app: platform-api
  ports:
    - port: __SERVICE_PORT__
      targetPort: 8080
