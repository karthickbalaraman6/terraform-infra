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

#RDS instance
resource "aws_db_instance" "postgres" {
  identifier              = "my-postgres-db"
  allocated_storage       = 20
  engine                  = "postgres"
  engine_version          = "15.3"
  instance_class          = "db.t3.micro"
  username                = "admin"
  password                = "Admin12345"
  db_subnet_group_name    = aws_db_subnet_group.db_subnet.id
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  skip_final_snapshot     = true
}

#RDS Subnet
resource "aws_db_subnet_group" "db_subnet" {
  name       = "db-subnet-group"
  subnet_ids = [aws_subnet.private1.id, aws_subnet.private2.id]
}

#Security Group for RDS

resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Allow DB access from EC2"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]  # EC2 SG can access DB
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#s3
resource "aws_s3_bucket" "artifacts" {
  bucket = "terraform-bucket-27987"
  force_destroy = true
}



# EC2 instance with user_data to install nginx
resource "aws_instance" "web" {
ami = data.aws_ami.ami-0c398cb65a93047f2.id
tags = {
  Name = "Terraform-EC2"
}
}