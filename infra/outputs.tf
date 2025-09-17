output "public_ip" {
  value = aws_instance.fastapi_server.public_ip
}

output "app_url" {
  value = "http://${aws_instance.fastapi_server.public_ip}"
}
