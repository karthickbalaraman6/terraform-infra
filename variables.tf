variable "aws_region" {
  default = "us-east-1"
}

variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet1_cidr" {
  default = "10.0.2.0/24"
}

variable "private_subnet2_cidr" {
  default = "10.0.3.0/24"
}

variable "key_name" {
  description = "EC2 Key pair name"
  default     = "terraform-key"
}
