variable "env" {
  description = "Deployment environment (e.g. dev, staging, prod)"
  type        = string
}

variable "tags" {
  type = map
  description = "Tags to add to AWS resources"
}

variable "vpc_cidr" {
  description = "VPC cidr block"
  type        = string
}

variable "public_subnets" {
  description = "The public subnets for the VPC"
  type        = map(number)
  default = {
    "public-subnet-1" = 1
    "public-subnet-2" = 2
    "public-subnet-3" = 3
  }
}

variable "private_subnets" {
  description = "The private subnets for the VPC"
  type        = map(number)
  default = {
    "private-subnet-1" = 1
    "private-subnet-2" = 2
    "private-subnet-3" = 3
  }
}