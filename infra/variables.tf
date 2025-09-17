variable "key_name" {
  description = "EC2 Key Pair"
  type        = string
}

variable "docker_image" {
  description = "DockerHub image for FastAPI app"
  type        = string
}

variable "docker_username" {
  description = "DockerHub username (if private)"
  type        = string
  default     = ""
}

variable "docker_password" {
  description = "DockerHub password (if private)"
  type        = string
  default     = ""
}
