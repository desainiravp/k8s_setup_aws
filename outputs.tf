output "master_public_ip" {
  description = "Public IP of Kubernetes master node"
  value       = aws_instance.master.public_ip
}

output "worker_public_ips" {
  description = "Public IPs of Kubernetes worker nodes"
  value       = [for instance in aws_instance.worker : instance.public_ip]
}
