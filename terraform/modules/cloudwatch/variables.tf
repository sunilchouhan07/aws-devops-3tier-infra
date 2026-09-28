variable "env" {
  type = string
}

variable "project" {
  type = string
}

variable "sns_topic_arn" {
  type = string
}

variable "asg_name" {
  type = string
}

variable "instance_capacity_threshold" {
  type = number
}

variable "alb_rejected_connections" {
  type = number
}

variable "alb_threshold" {
  type = number
}

variable "cpu_threshold" {
  type = number
}

variable "memory_threshold" {
  type = number
}

variable "disk_threshold" {
  type = number
}

variable "alb_5xx_threshold" {
  type = number
}

variable "alb_arn_suffix" {
  type = string
}

variable "target_group_arn_suffix" {
  type = string
}