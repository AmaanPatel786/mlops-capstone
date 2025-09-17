provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  owners = ["099720109477"] # canonical
}

resource "aws_security_group" "ssh_http" {
  name = "ssh_http"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.ssh_http.name]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io
              docker login -u ${var.dockerhub_user} -p ${var.dockerhub_token}
              docker pull ${var.dockerhub_user}/mlops-capstone:latest
              docker run -d -p 8000:8000 --name mlops_cap ${var.dockerhub_user}/mlops-capstone:latest
              EOF

  tags = {
    Name = "mlops-cap-app"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "mlops-capstone-key"
  public_key = file("~/.ssh/id_rsa.pub")
}
