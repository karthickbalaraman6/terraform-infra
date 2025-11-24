terraform {
required_version = ">= 1.0"
required_providers {
aws = {
source = "hashicorp/aws"
version = "~> 5.0"
}
}
}


provider "aws" {
region = var.aws_region
}


# Remote backend example (fill values or pass via -backend-config)
terraform {
backend "s3" {
bucket = "terraform-bucket-27987" # CHANGE ME
key = "terraform/state.tfstate"
region = "us-east-1" # CHANGE ME
dynamodb_table = "terraform-locks" # CHANGE ME
encrypt = true
}
}