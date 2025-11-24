variable "aws_region" {
description = "AWS region"
type = string
default = "us-east-1"
}


variable "vpc_cidr" {
type = string
default = "10.0.0.0/16"
}


variable "public_subnet_cidr" {
type = string
default = "10.0.1.0/24"
}


variable "allowed_cidr" {
description = "CIDR allowed for SSH (your IP)"
type = string
default = "54.91.49.109/32" # change to your IP for security
}


variable "key_name" {
type = string
default = "realubuntu1" # CHANGE ME to your EC2 key pair name
}


variable "instance_type" {
type = string
default = "t3.micro"
}


variable "db_password" {
description = "RDS master password"
type = string
sensitive = true
}