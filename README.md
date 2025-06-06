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
