# k8s_setup_aws
**SSH into all Node**
**Run Following command** 
mkdir k8s
cd k8s
Add k8s_setup.sh file
chmod +x k8s_setup.sh
**on Master Node**
./k8s_setup.sh master
kubeadm token create --print-join-command
 **on worker Node**
 ./k8s_setup.sh worker
 sudo kubeadm Join .......

 Kubernetes cluster on ubuntu 24.04 with 1 master and 2 worker nodes
 reference https://www.cherryservers.com/blog/install-kubernetes-ubuntu

 Monitoring setup with helm
-curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
-helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
-helm repo add grafana https://grafana.github.io/helm-charts
-helm repo update
-kubectl create namespace monitoring
-helm install prometheus-stack prometheus-community/kube-prometheus-stack \
  -n monitoring \
  -f custom-values.yaml
-helm install loki grafana/loki-stack \
  -n monitoring \
  --set grafana.enabled=false \
  --set promtail.enabled=true

