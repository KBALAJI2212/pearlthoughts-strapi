provider "aws" {
  region = "us-east-2"
}


resource "aws_instance" "strapi" {
  ami                         = "ami-0eb9d6fc9fab44d24" #Amazon Linux 2023 AMI for us-east-2
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["sg-038861db81239cf2a"]   # I am using default VPC and Default VPC Security Group
  subnet_id                   = "subnet-0cc813dd4d76bf797" # Using default Subnet (us-east-2b)
  key_name                    = "strapi_key_balaji"        #Create own keypair to have SSH access

  root_block_device {
    volume_size = 20
  }

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install git -y
git clone https://github.com/KBALAJI2212/pearlthoughts-strapi.git
cd pearlthoughts-strapi/Day-6
chmod +x strapi-deployment.sh
bash strapi-deployment.sh
EOF
  )

  tags = {
    Name  = "Strapi_Instance(Balaji)"
    Owner = "Balaji"
  }
}

output "strapi_address" {
  value = "http://${aws_instance.strapi.public_ip}:1337/admin"
}
