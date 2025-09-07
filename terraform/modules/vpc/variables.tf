variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "subnet_cidrs" {
  description = "A list of CIDR blocks for the subnets within the VPC"
  type        = list(string)
}

variable "availability_zones" {
  description = "A list of availability zones to deploy the subnets into"
  type        = list(string)
}
