terraform {
  required_version = "~> 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.0"
    }
  }
}

resource "aws_eip" "web_ip" {
  instance = aws_instance.web.id
}

resource "aws_instance" "web" {
  ami                    = "ami-06c39ed6b42908a36"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = "Dec27KeyPair"
  user_data              = file("init-script.sh")

  tags                   = {
    Name = "web"
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow 80 port inbound traffic"

  ingress {
    description      = "For traffic from port 80"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}