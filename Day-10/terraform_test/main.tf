provider "aws" {
  region = "us-east-2"
}


resource "aws_instance" "strapi" {
  ami           = "ami-0eb9d6fc9fab44d24" #Amazon Linux 2023 AMI for us-east-2
  instance_type = "t3.micro"

  tags = {
    Name  = "Strapi_Instance(Balaji)"
    Owner = "Balaji"
  }
}

variable "image_tag" {

}
