variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "instance_ids" {
  description = "EC2 instance IDs to attach to target group"
  type        = list(string)
}