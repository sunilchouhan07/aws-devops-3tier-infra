variable "env" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_sub_id" {
  type = list(string)
}

variable "health_interval" {
  type = number
}

variable "timeout" {
  type = number
}

variable "healthy_threshold" {
  type = number
}

variable "unhealthy_threshold" {
  type = number
}
