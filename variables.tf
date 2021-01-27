variable "aws_region" {
  default = "ap-south-1"
}

variable "vpc_cidr" {
  default = "10.20.0.0/16"
}

variable "public_subnets_cidr" {
  type    = "list"
  default = ["10.20.1.0/24", "10.20.2.0/24"]
}
variable "private_subnet_cidr" {
  type    = "list"
  default = ["10.20.3.0/24", "10.20.4.0/24"]
}

variable "azs" {
  type    = "list"
  default = ["ap-south-1a", "ap-south-1b"]
}

variable "webservers_ami" {
  default = "ami-04b1ddd35fd71475a"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "public_key_path" {
  description = "Enter the path to the SSH Public Key to add to AWS."
  default     = "/home/ec2-user/terraform/VPC-terraform/terraform-demo.pub.pem"
}
variable "key_name" {
  description = "Key name for SSHing into EC2"
  default     = "terraform-demo.pub"
}

variable "ec2_count" {
  default = 1
}
