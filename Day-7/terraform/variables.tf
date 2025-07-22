variable "aws_region" {
  description = "AWS Resources deployment region"
  type        = string
  default     = "us-east-2"
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
  default     = "ami-0eb9d6fc9fab44d24" #Amazon Linux 2023 AMI for us-east-2
}

variable "ssh_key_name" {
  description = "SSH key name"
  type        = string
  default     = "strapi_key_balaji" #Create own keypair to have SSH access
}

variable "image_tag" {
  description = "Docker image tag" #Will be passed by Github Actions
  type        = string
}
