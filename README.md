# Unofficial Unstructured API Helm Chart

I am not affilated with [Unstructured-IO](https://github.com/Unstructured-IO) I just like their product and want to run it in Kubernetes.

This is an unofficial Helm chart repository for the Unstructured API: [unstructured-api](https://github.com/Unstructured-IO/unstructured-api) used for document loading in LLM RAG Applications. The Helm chart is a wrapper that makes it easy to deploy the Unstructured API on a Kubernetes cluster.

Please use at your own risk!

## Table of Contents

- [Introduction](#introduction)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Preequistes](#prerequisites)
- [Configuration](#configuration)

## Introduction

This Helm chart wraps the Unstructured API for easy deployment on Kubernetes clusters. It simplifies the process of setting up the API to handle document loading in LLM RAG applications.

## Installation

To install the chart, follow these steps:

1. Add the chart repository: `helm repo add unstructured-api https://kkacsh321.github.io/unstructured-api-helm-chart`

2. See the version of chart: `helm search repo unstructured-api`

3. Install the chart: `helm install unstructured-api unstructured-api/unstructured-api -n <namespace>`

4. or with a values file `helm install unstructured-api unstructured-api/unstructured-api -n <namespace> -f values.yaml`

## Usage

Once installed, you can access the API through the provided service endpoint. For more detailed usage instructions, refer to the [official documentation](https://github.com/Unstructured-IO/unstructured-api).

## Contributing

Contributions are welcome! Please check out the [contribution guidelines](CONTRIBUTING.md) for more details.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.0+

## Configuration

Customize the deployment by modifying the Helm chart's values. Refer to the `values.yaml` file for available configuration options.

The following table lists the configurable parameters of the Unstructured API Helm chart and their default values:

| Parameter                     | Description                                                  | Default                    |
|-------------------------------|--------------------------------------------------------------|----------------------------|
| `image.repository`             | Docker image repository                                      | `unstructuredio/unstructured-api` |
| `image.tag`                    | Docker image tag                                             | `latest`                   |
| `image.pullPolicy`             | Image pull policy                                            | `IfNotPresent`             |
| `replicaCount`                 | Number of pods                                               | `1`                        |
| `service.type`                 | Kubernetes service type                                      | `ClusterIP`                |
| `service.port`                 | Service port                                                 | `80`                       |
| `resources`                    | CPU/Memory resource requests and limits                      | `{}`                       |
| `nodeSelector`                 | Node labels for pod assignment                               | `{}`                       |
| `tolerations`                  | Tolerations (required for running on tainted nodes)          | `[]`                       |
| `affinity`                     | Pods scheduling affinity                                     | `{}`                       |
| `UNSTRUCTURED_PARALLEL_MODE_ENABLED` | Set to true to process individual PDF pages remotely; default is false. | `false` |
| `UNSTRUCTURED_PARALLEL_MODE_URL` | Location to send PDF pages asynchronously; no default setting. | `{}` |
| `UNSTRUCTURED_PARALLEL_MODE_THREADS` | Number of threads making requests at once; default is 3. | `3` |
| `UNSTRUCTURED_PARALLEL_MODE_SPLIT_SIZE` | Number of pages to be processed in one request; default is 1. | `1` |
| `UNSTRUCTURED_PARALLEL_RETRY_ATTEMPTS` | Number of retry attempts on a retryable error; default is 2. | `2` |

```yaml
# Default values for unstructured-api.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.
replicaCount: 2
image:
  repository: downloads.unstructured.io/unstructured-io/unstructured-api
  pullPolicy: IfNotPresent
  # Overrides the image tag whose default is the chart appVersion.
  tag: "0.0.80"

# Unstructured Environment Variables
UNSTRUCTURED_PARALLEL_MODE_ENABLED: "false"
UNSTRUCTURED_PARALLEL_MODE_URL: ""
UNSTRUCTURED_PARALLEL_MODE_THREADS: "3"
UNSTRUCTURED_PARALLEL_MODE_SPLIT_SIZE: "1"
UNSTRUCTURED_PARALLEL_MODE_RETRY_ATTEMPTS: "2"

imagePullSecrets: []
nameOverride: ""
fullnameOverride: ""
serviceAccount:
  # Specifies whether a service account should be created
  create: true
  # Automatically mount a ServiceAccount's API credentials?
  automount: true
  # Annotations to add to the service account
  annotations: {}
  # The name of the service account to use.
  # If not set and create is true, a name is generated using the fullname template
  name: ""

podAnnotations: {}
podLabels: {}

podSecurityContext: {}
  # fsGroup: 2000

securityContext: {}
  # capabilities:
  #   drop:
  #   - ALL
  # readOnlyRootFilesystem: true
  # runAsNonRoot: true
  # runAsUser: 1000

service:
  type: NodePort
  port: 8000

ingress:
  enabled: false
  className: ""
  annotations: {}
    # kubernetes.io/ingress.class: nginx
    # kubernetes.io/tls-acme: "true"
  hosts:
    - host: chart-example.local
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls: []
  #  - secretName: chart-example-tls
  #    hosts:
  #      - chart-example.local
resources: {}
  # We usually recommend not to specify default resources and to leave this as a conscious
  # choice for the user. This also increases chances charts run on environments with little
  # resources, such as Minikube. If you do want to specify resources, uncomment the following
  # lines, adjust them as necessary, and remove the curly braces after 'resources:.'  
  # limits:
  #   cpu: 100m
  #   memory: 128Mi
  # requests:
  #   cpu: 100m
  #   memory: 128Mi

# livenessProbe:
#   httpGet:
#     path: /
#     port: http
# readinessProbe:
#   httpGet:
#     path: /
#     port: http

autoscaling:
  enabled: false
  minReplicas: 1
  maxReplicas: 100
  targetCPUUtilizationPercentage: 80
  # targetMemoryUtilizationPercentage: 80

# Additional volumes on the output Deployment definition.
volumes: []
# - name: foo
#   secret:
#     secretName: mysecret
#     optional: false

# Additional volumeMounts on the output Deployment definition.
volumeMounts: []
# - name: foo
#   mountPath: "/etc/foo"
#   readOnly: true

nodeSelector: {}

tolerations: []

affinity: {}
```

