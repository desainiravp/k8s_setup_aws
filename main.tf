provider "aws" {
  region = "us-east-1"
}

variable "ssh_user" {
  default = "ubuntu"
}

resource "aws_security_group" "k8s_sg" {
  name        = "k8s_sg"
  description = "Allow Kubernetes ports"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Kubernetes API server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow NodePort services"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "k8s_key" {
  key_name   = "k8s_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Master Node
resource "aws_instance" "master" {
  ami                    = "ami-0e2c8caa4b6378d8c" # Ubuntu 22.04
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.k8s_key.key_name
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]

  tags = {
    Name = "k8s-master"
  }

  # Copy setup script
  provisioner "file" {
    source      = "k8s_setup.sh"
    destination = "/home/ubuntu/k8s_setup.sh"

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }
}

# Worker Nodes (2 nodes)
resource "aws_instance" "worker" {
  count                  = 2
  ami                    = "ami-0e2c8caa4b6378d8c"
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.k8s_key.key_name
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]

  tags = {
    Name = "k8s-worker-${count.index + 1}"
  }

  # Copy setup script
  provisioner "file" {
    source      = "k8s_setup.sh"
    destination = "/home/ubuntu/k8s_setup.sh"

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }

}

