provider "aws" {
  region = "us-east-2"
}

data "aws_vpc" "default_vpc" {
  default = true
}

resource "aws_security_group" "docker_swarm_sg" {
  name        = "docker-swarm-sg-balaji"
  description = "Security group for Docker Swarm communication"
  vpc_id      = data.aws_vpc.default_vpc.id

  # SSH Access
  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Swarm Manager Port (TCP 2377)
  ingress {
    description = "Swarm manager communication"
    from_port   = 2377
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default_vpc.cidr_block]
  }

  # Node communication (TCP and UDP 7946)
  ingress {
    description = "Node communication TCP"
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default_vpc.cidr_block]
  }

  ingress {
    description = "Node communication UDP"
    from_port   = 7946
    to_port     = 7946
    protocol    = "udp"
    cidr_blocks = [data.aws_vpc.default_vpc.cidr_block]
  }

  # Overlay network (UDP 4789)
  ingress {
    description = "Overlay network"
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = [data.aws_vpc.default_vpc.cidr_block]
  }

  # Allow all egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "docker-swarm-sg-balaji"
  }
}

resource "aws_instance" "swarm_instances" {

  count                  = 3
  ami                    = "ami-0eb9d6fc9fab44d24" #Amazon Linux 2023 AMI for us-east-2
  instance_type          = "t3.small"
  vpc_security_group_ids = [aws_security_group.docker_swarm_sg.id]
  key_name               = "strapi_key_balaji" #Create own keypair to have SSH access

  user_data = base64encode(<<EOF
#!/bin/bash
dnf update -y
dnf install docker -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user
EOF
  )

  tags = {
    Name = "Docker-swarm-balaji-${count.index + 1}"
  }

}

output "ip_addresses" {
  value = [for instance in aws_instance.swarm_instances : instance.public_ip]
}
