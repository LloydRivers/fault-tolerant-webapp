variable "bucket_domain_name" {
  description = "The domain name of the S3 bucket (e.g., bucket.s3.amazonaws.com)"
  type        = string
}

variable "origin_id" {
  description = "A unique identifier for the CloudFront origin"
  type        = string
  default     = "s3OriginApp"
}

variable "aliases" {
  description = "Custom domain names for the CloudFront distribution"
  type        = list(string)
  default     = []
}

variable "default_root_object" {
  description = "The default object to serve (e.g., index.html)"
  type        = string
  default     = "index.html"
}

variable "enabled" {
  description = "Whether the CloudFront distribution is enabled"
  type        = bool
  default     = true
}
