variable "vpc_cidr" {
  type = string
}

variable "env" {
  type = string
}

variable "public_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "private_subnets_app" {
  type = map(object({
    cidr = string
    az   = string
  }))
}


variable "private_subnets_rds" {
  type = map(object({
    cidr = string
    az   = string
  }))
}



variable "nat_subnet_name" {
  type = string

  validation {
    condition     = contains(keys(var.public_subnets), var.nat_subnet_name)
    error_message = "nat_subnet_name must be one of the public_subnets keys"
  }


}