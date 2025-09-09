variable "vpc_id" {
  type        = string
  description = "VPC ID for the EC2 instance"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for ASG"
}

variable "alb_sg_id" {
  type        = string
  description = "Security Group ID of ALB"
}

variable "ami" {
  type        = string
  description = "AMI ID for EC2"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  type        = string
  description = "Key pair name for EC2"
}

variable "desired_capacity" {
  type        = number
  default     = 1
}

variable "min_size" {
  type        = number
  default     = 1
}

variable "max_size" {
  type        = number
  default     = 2
}

variable "target_group_arn" {
  description = "Target group ARN from ALB module"
  type        = string
}

