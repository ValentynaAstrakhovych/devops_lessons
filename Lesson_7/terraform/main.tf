terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.5"
    }
  }

  backend "s3" {
    bucket = "devopsmay24lesson7"
    key    = "terraform_my_infra.tfstate"
    region = "us-east-1"
  }

  required_version = ">= 1.3"
}

#  provider "aws" {
#  region = "us-east-1"
#  access_key = ""
#  secret_key = ""
#   }

resource "aws_instance" "test_t2_micro" {
  # ami                    = "ami-0a0c8eebcdd6dcbd0" # ubuntu arm64 
  ami                    = "ami-0c7217cdde317cfec" # Ubuntu amd64 (x86_64)
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  key_name = "dev_may24" # Your key name here
  subnet_id = "subnet-01f355478c4ee7782"
  tags = {
    Name = "Dads Jokes Instance"
    Purpose = "training lesson 7"
  }
}

resource "random_pet" "sg" {}

resource "aws_security_group" "web-sg" {
  name = "${random_pet.sg.id}-sg"
  ingress {
    from_port   = 22
    to_port     = 9001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 22
    to_port     = 9001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "ip" {
  value = aws_instance.test_t2_micro.public_ip
}