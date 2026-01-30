# Kubernetes Cluster Setup on AWS (Ubuntu 24.04)

This guide helps you set up a **Kubernetes cluster** on **Ubuntu 24.04** with **1 Master node** and **2 Worker nodes**, along with **Monitoring (Prometheus + Grafana + Loki)** using Helm.

---

## 📌 Prerequisites

* 3 Ubuntu 24.04 EC2 Instances

  * 1 Master Node
  * 2 Worker Nodes
* SSH access to all nodes
* sudo privileges

---

## 🚀 Step 1 — SSH Into All Nodes

```
ssh ubuntu@<node-ip>
```

---

## 🚀 Step 2 — Create Setup Directory

```
mkdir k8s
cd k8s
```

---

## 🚀 Step 3 — Add the Script File

Create a file named `k8s_setup.sh` inside the `k8s` directory.

Give execute permission:

```
chmod +x k8s_setup.sh
```

---

## 🚀 Step 4 — Setup Kubernetes

### 🟦 On Master Node

Run:

```
./k8s_setup.sh master
```

Then generate the join command:

```
kubeadm token create --print-join-command
```

Copy the output join command.

---

### 🟩 On Worker Nodes

Run:

```
./k8s_setup.sh worker
```

Then join workers to the cluster:

```
sudo kubeadm join <token-command-from-master>
```

---

## 📘 Reference

This guide is based on the [Cherry Servers Kubernetes installation guide](https://www.cherryservers.com/blog/install-kubernetes-ubuntu).

---

# 📊 Monitoring Setup Using Helm

This setup installs a complete monitoring stack:

* **Prometheus** - Metrics collection and alerting
* **Grafana** - Visualization dashboards
* **Loki** - Log aggregation
* **Promtail** - Log collector agent

---

## 🛠 Step 1 — Install Helm

```
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
```

---

## 🛠 Step 2 — Add Helm Repositories

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

---

## 🛠 Step 3 — Create Monitoring Namespace

```
kubectl create namespace monitoring
```

---

## 🛠 Step 4 — Install Prometheus + Grafana Stack

Make sure you have your `custom-values.yaml` ready.

```
helm install prometheus-stack prometheus-community/kube-prometheus-stack \
  -n monitoring \
  -f custom-values.yaml
```

---

## 🛠 Step 5 — Install Loki + Promtail

```
helm install loki grafana/loki-stack \
  -n monitoring \
  --set grafana.enabled=false \
  --set promtail.enabled=true
```

---

# ✅ Next Steps

Once deployed, you can access:

* **Prometheus UI** - Metrics and alerting
* **Grafana Dashboard** - Visualization and analytics
* **Loki Logs** - Centralized log viewing

---

## 📚 Additional Resources

* [Kubernetes Documentation](https://kubernetes.io/docs/)
* [Prometheus Documentation](https://prometheus.io/docs/)
* [Grafana Documentation](https://grafana.com/docs/)
* [Loki Documentation](https://grafana.com/docs/loki/latest/)

---

## ❓ Troubleshooting

For common issues and solutions, refer to the official Kubernetes and Helm documentation linked above.



