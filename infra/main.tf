provider "aws" {
  region = "ap-south-1" # change to your region (e.g., Mumbai)
}

resource "aws_instance" "fastapi_server" {
  ami           = "ami-08e5424edfe926b43" # Ubuntu 22.04 LTS in ap-south-1
  instance_type = "t2.micro"
  key_name      = var.key_name             # your EC2 key pair

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker

              # login to dockerhub (optional if private repo)
              # echo "${var.docker_password}" | docker login -u "${var.docker_username}" --password-stdin

              # pull & run FastAPI container
              docker run -d -p 80:8000 ${var.docker_image}
              EOF

  tags = {
    Name = "fastapi-mlops"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
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

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.allow_http.id
  network_interface_id = aws_instance.fastapi_server.primary_network_interface_id
}
