terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "app_server" {
  count                  = 2
  ami                    = "ami-0d71ea30463e0ff8d"
  instance_type          = "t2.micro"
  key_name               = "alan-sinensia"
  vpc_security_group_ids = [var.vpc_security_group_ids]
  subnet_id              = "subnet-054da9dce1bf36bd5"

  tags = {
    Name = var.instance_name
    APP  = "vue2048"
  }
}

