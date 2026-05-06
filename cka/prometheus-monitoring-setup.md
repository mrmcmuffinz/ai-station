# Prometheus + Node Exporter: End-to-End Setup Guide

## Overview

This guide covers deploying a host-based Prometheus instance via `nerdctl` Compose alongside a Node Exporter DaemonSet inside a kubeadm cluster. Prometheus runs outside the cluster for an independent failure domain and uses Kubernetes Service Discovery to automatically scrape targets.

```
┌─────────────────────────────────────────────────────────┐
│  Host (nerdctl rootless)                                │
│                                                         │
│  ┌──────────────────────┐                               │
│  │  Prometheus :9090    │                               │
│  │  (compose stack)     │──────── scrapes ─────────┐   │
│  └──────────────────────┘                          │   │
└────────────────────────────────────────────────────│───┘
                                                     │
┌────────────────────────────────────────────────────│───┐
│  kubeadm Cluster                                   │   │
│                                                    ▼   │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐   │
│  │ node-exp    │  │ node-exp    │  │ node-exp    │   │
│  │ :9100       │  │ :9100       │  │ :9100       │   │
│  │ (node 1)    │  │ (node 2)    │  │ (control)   │   │
│  └─────────────┘  └─────────────┘  └─────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## Prerequisites

- Host running Ubuntu 24.04 with nerdctl rootless configured
- A running kubeadm cluster with `kubectl` access
- `nerdctl compose` available (`nerdctl compose version` to verify)

---

## Part 1: Prometheus on the Host via nerdctl Compose

### 1.1 — Directory Structure

```bash
mkdir -p ~/monitoring/prometheus/data
chmod 777 ~/monitoring/prometheus/data  # Prometheus runs as UID 65534
```

Your layout will be:

```
~/monitoring/
├── compose.yaml
└── prometheus/
    ├── prometheus.yml
    └── data/           # persistent TSDB storage
```

### 1.2 — Prometheus Configuration

Create `~/monitoring/prometheus/prometheus.yml`:

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:

  # Prometheus scrapes itself
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  # Auto-discover nodes via Kubernetes API
  - job_name: 'kubernetes-nodes'
    kubernetes_sd_configs:
      - role: node
        api_server: https://<control-plane-ip>:6443
        tls_config:
          ca_file: /etc/prometheus/k8s-ca.crt
        bearer_token_file: /etc/prometheus/k8s-token
    scheme: https
    tls_config:
      ca_file: /etc/prometheus/k8s-ca.crt
    bearer_token_file: /etc/prometheus/k8s-token
    relabel_configs:
      - action: labelmap
        regex: __meta_kubernetes_node_label_(.+)

  # Auto-discover pods with scrape annotation
  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
      - role: pod
        api_server: https://<control-plane-ip>:6443
        tls_config:
          ca_file: /etc/prometheus/k8s-ca.crt
        bearer_token_file: /etc/prometheus/k8s-token
    relabel_configs:
      # Only scrape pods that opt in
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: "true"
      # Honor custom metrics path annotation
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
        action: replace
        target_label: __metrics_path__
        regex: (.+)
      # Honor custom port annotation
      - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
        action: replace
        regex: ([^:]+)(?::\d+)?;(\d+)
        replacement: $1:$2
        target_label: __address__
      - action: labelmap
        regex: __meta_kubernetes_pod_label_(.+)
      - source_labels: [__meta_kubernetes_namespace]
        action: replace
        target_label: kubernetes_namespace
      - source_labels: [__meta_kubernetes_pod_name]
        action: replace
        target_label: kubernetes_pod_name
```

> Replace `<control-plane-ip>` with your actual control plane IP. You'll populate the token and CA cert files in Part 2.

### 1.3 — Compose File

Create `~/monitoring/compose.yaml`:

```yaml
services:
  prometheus:
    image: docker.io/prom/prometheus:v2.51.2
    container_name: prometheus
    restart: always
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - ./prometheus/k8s-ca.crt:/etc/prometheus/k8s-ca.crt:ro
      - ./prometheus/k8s-token:/etc/prometheus/k8s-token:ro
      - ./prometheus/data:/prometheus
    command:
      - --config.file=/etc/prometheus/prometheus.yml
      - --storage.tsdb.path=/prometheus
      - --storage.tsdb.retention.time=15d
      - --web.enable-lifecycle
      - --web.enable-admin-api
```

> `--web.enable-lifecycle` allows hot-reloading config via `curl -X POST http://localhost:9090/-/reload` without restarting the container.

### 1.4 — Start Prometheus

```bash
cd ~/monitoring
nerdctl compose up -d
nerdctl compose logs -f prometheus
```

Verify it's reachable:

```bash
curl http://localhost:9090/-/ready
```

The UI will be available at `http://<host-ip>:9090` but it won't have any targets yet — that comes after Part 2.

---

## Part 2: Node Exporter DaemonSet in the Cluster

### 2.1 — Create the Monitoring Namespace

```bash
kubectl create namespace monitoring
```

### 2.2 — RBAC for Prometheus Service Discovery

Prometheus needs read access to the Kubernetes API to discover nodes and pods.

Save as `prometheus-rbac.yaml`:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: prometheus
  namespace: monitoring
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: prometheus
rules:
  - apiGroups: [""]
    resources:
      - nodes
      - nodes/metrics
      - services
      - endpoints
      - pods
    verbs: ["get", "list", "watch"]
  - apiGroups: [""]
    resources:
      - configmaps
    verbs: ["get"]
  - nonResourceURLs:
      - /metrics
      - /metrics/cadvisor
    verbs: ["get"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: prometheus
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: prometheus
subjects:
  - kind: ServiceAccount
    name: prometheus
    namespace: monitoring
```

```bash
kubectl apply -f prometheus-rbac.yaml
```

Verify:

```bash
kubectl -n monitoring get serviceaccount prometheus
kubectl get clusterrolebinding prometheus
```

### 2.3 — Node Exporter DaemonSet

Save as `node-exporter.yaml`:

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-exporter
  namespace: monitoring
  labels:
    app: node-exporter
spec:
  selector:
    matchLabels:
      app: node-exporter
  template:
    metadata:
      labels:
        app: node-exporter
      annotations:
        prometheus.io/scrape: "true"   # opt-in to pod SD scraping
        prometheus.io/port: "9100"
        prometheus.io/path: "/metrics"
    spec:
      serviceAccountName: prometheus
      hostNetwork: true   # use host network namespace for accurate metrics
      hostPID: true       # see host process IDs for process metrics
      tolerations:
        - operator: Exists  # schedule on all nodes including control-plane
      containers:
        - name: node-exporter
          image: docker.io/prom/node-exporter:v1.8.2
          args:
            - --path.rootfs=/host
          ports:
            - containerPort: 9100
              hostPort: 9100
          securityContext:
            readOnlyRootFilesystem: true
            runAsNonRoot: true
            runAsUser: 65534   # nobody
          volumeMounts:
            - name: root
              mountPath: /host
              readOnly: true
              mountPropagation: HostToContainer
      volumes:
        - name: root
          hostPath:
            path: /
```

```bash
kubectl apply -f node-exporter.yaml
```

### 2.4 — Headless Service

The headless service (`clusterIP: None`) returns individual pod IPs rather than a single virtual IP, which is useful for service discovery.

Save as `node-exporter-svc.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: node-exporter
  namespace: monitoring
  labels:
    app: node-exporter
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "9100"
spec:
  clusterIP: None
  ports:
    - port: 9100
      targetPort: 9100
      name: metrics
  selector:
    app: node-exporter
```

```bash
kubectl apply -f node-exporter-svc.yaml
```

### 2.5 — Verify the DaemonSet

```bash
# One pod per node?
kubectl -n monitoring get pods -o wide

# Endpoints populated?
kubectl -n monitoring get endpoints node-exporter

# Spot check metrics from a node directly
curl http://<any-node-ip>:9100/metrics | head -20
```

You should see one pod per node in `Running` state and each node IP listed as an endpoint.

---

## Part 3: Wire Prometheus to the Cluster

### 3.1 — Extract the Cluster CA Certificate

```bash
kubectl config view --raw \
  -o jsonpath='{.clusters[0].cluster.certificate-authority-data}' \
  | base64 -d > ~/monitoring/prometheus/k8s-ca.crt
```

### 3.2 — Generate a Long-Lived Token

```bash
kubectl -n monitoring create token prometheus --duration=8760h \
  > ~/monitoring/prometheus/k8s-token
```

> This token is valid for 1 year. Set a reminder to rotate it. A more robust approach is to create a Secret-based token (type `kubernetes.io/service-account-token`) which doesn't expire, but that requires additional cluster configuration.

### 3.3 — Get Your Node IPs

```bash
kubectl get nodes -o wide
```

Update `prometheus.yml` with your actual `<control-plane-ip>` if you haven't already.

### 3.4 — Reload Prometheus Config

Since you started Prometheus with `--web.enable-lifecycle`, no restart is needed:

```bash
curl -X POST http://localhost:9090/-/reload
```

---

## Part 4: Verify End-to-End

### 4.1 — Check Targets in the UI

Open `http://<host-ip>:9090/targets`

You should see:

| Job | Targets | State |
|---|---|---|
| `prometheus` | localhost:9090 | UP |
| `kubernetes-nodes` | one per node | UP |
| `kubernetes-pods` | node-exporter pods | UP |

### 4.2 — Run Test Queries

In the Prometheus UI (`http://<host-ip>:9090/graph`), try:

```promql
# CPU usage per node
rate(node_cpu_seconds_total{mode!="idle"}[5m])

# Available memory per node
node_memory_MemAvailable_bytes

# Disk usage
node_filesystem_avail_bytes{mountpoint="/"}

# Node up/down status
up{job="kubernetes-nodes"}
```

### 4.3 — Useful nerdctl Commands

```bash
# Check container status
nerdctl compose ps

# Tail logs
nerdctl compose logs -f prometheus

# Restart after config change (if not using lifecycle reload)
nerdctl compose restart prometheus

# Stop the stack
nerdctl compose down

# Stop and remove volumes (wipes TSDB data)
nerdctl compose down -v
```

---

## Directory Reference

```
~/monitoring/
├── compose.yaml                  # Compose stack definition
└── prometheus/
    ├── prometheus.yml            # Scrape config + SD rules
    ├── k8s-ca.crt               # Cluster CA cert (from kubectl)
    ├── k8s-token                 # SA token (rotate annually)
    └── data/                     # TSDB persistent storage
```

```
cluster: namespace/monitoring
├── serviceaccount/prometheus     # Identity for SD auth
├── clusterrole/prometheus        # Read-only API permissions
├── clusterrolebinding/prometheus # Binds role to SA
├── daemonset/node-exporter       # One pod per node
└── service/node-exporter         # Headless service (clusterIP: None)
```

---

## Troubleshooting

| Symptom | Check |
|---|---|
| Targets show `DOWN` | `curl http://<node-ip>:9100/metrics` from the host — firewall? |
| SD returns no targets | Token permissions — `kubectl auth can-i list nodes --as=system:serviceaccount:monitoring:prometheus` |
| Prometheus won't start | `nerdctl compose logs prometheus` — likely a bad `prometheus.yml` |
| Pods not on control-plane | Verify `tolerations: - operator: Exists` in DaemonSet spec |
| Token auth fails | Confirm CA cert matches cluster — `openssl x509 -in k8s-ca.crt -noout -subject` |

---

## What's Next

Once this is running, natural follow-on steps are:

- **Grafana** — deploy alongside Prometheus in the compose stack for dashboards (`docker.io/grafana/grafana`)
- **kube-state-metrics** — cluster-level metrics (deployment health, pod counts, resource requests vs limits)
- **AlertManager** — add alerting rules and notification routing to the compose stack
- **kube-prometheus-stack** — deploy the Helm chart into the cluster and compare what it abstracts vs what you built manually
- **Thanos sidecar** — attach to Prometheus for long-term storage and multi-cluster federation
