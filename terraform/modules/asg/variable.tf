variable "app_vpc_id" {
  type = string
}

variable "alb_sg_id" {
  type = string
}

variable "private_subnets_id" {
  type = list(string)
}

variable "tg_arn" {
  type = string
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "rbd_size" {
  type = number
}

variable "key_name" {
  type = string
}

variable "env" {
  type = string
}

variable "script" {
  type = string
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "desired_capacity" {
  type = number
}

variable "health_check_period" {
  type = number
}


variable "artifact_bucket_arn" {
  type = string
}

variable "artifact_bucket_name" {
  type = string
}

variable "db_host" {
  type = string
}

variable "db_name" {
  type = string 
}

variable "db_user" {
  type = string
}

variable "db_password" {
  type = string
  sensitive = true
}
