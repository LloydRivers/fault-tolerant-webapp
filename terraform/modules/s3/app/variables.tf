variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "enable_versioning" {
  description = "Enable versioning on the bucket"
  type        = bool
  default     = true
}

variable "objects" {
  description = "List of files to upload to the bucket"
  type = list(object({
    key    = string
    source = string
  }))
  default = []
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "dev"
}

variable "cloudfront_distribution_arn" {
  description = "Optional ARN of CloudFront distribution to allow access"
  type        = string
  default     = ""
}

variable "enable_cloudfront" {
  description = "Whether to attach CloudFront access policy to the bucket"
  type        = bool
  default     = false
}
