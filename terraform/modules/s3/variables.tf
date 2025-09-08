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

variable "default_root_object" {
  description = "Default root object for CloudFront"
  type        = string
  default     = "index.html"
}

variable "aliases" {
  description = "List of alternate domain names for CloudFront"
  type        = list(string)
  default     = []
}

variable "price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_200"
}

variable "geo_restrictions" {
  description = "List of country codes for CloudFront geo restriction"
  type        = list(string)
  default     = []
}

variable "cloudfront_distribution_arn" {
  description = "Optional ARN of CloudFront distribution to allow access"
  type        = string
  default     = ""
}

variable "enable_cloudfront" {
  description = "Whether to add CloudFront access policy to the bucket"
  type        = bool
  default     = false
}
