resource "aws_vpc" "main" {
cidr_block = var.vpc_cidr
tags = { Name = "tf-jenkins-vpc" }
}


resource "aws_subnet" "public" {
vpc_id = aws_vpc.main.id
cidr_block = var.public_subnet_cidr
map_public_ip_on_launch = true
tags = { Name = "tf-public-subnet" }
}


resource "aws_internet_gateway" "igw" {
vpc_id = aws_vpc.main.id
tags = { Name = "tf-igw" }
}


resource "aws_route_table" "public" {
vpc_id = aws_vpc.main.id
route {
cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.igw.id
}
tags = { Name = "tf-public-rt" }
}


resource "aws_route_table_association" "pub_assoc" {
subnet_id = aws_subnet.public.id
route_table_id = aws_route_table.public.id
}


resource "aws_security_group" "ssh_http" {
name = "tf-ssh-http"
description = "Allow SSH and HTTP"
vpc_id = aws_vpc.main.id


ingress {
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = [var.allowed_cidr]
}


ingress {
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}


egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
}


# EC2 instance with user_data to install nginx
resource "aws_instance" "web" {
ami = data.aws_ami.amazon_linux.id
tags = {
  Name = "Terraform-EC2"
}
}