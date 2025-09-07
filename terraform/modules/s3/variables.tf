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
