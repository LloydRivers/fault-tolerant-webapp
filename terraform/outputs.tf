# --- Images Bucket Outputs ---
output "images_bucket_id" {
  value       = module.images_bucket.bucket_id
  description = "The S3 bucket ID for images"
}

output "images_bucket_arn" {
  value       = module.images_bucket.bucket_arn
  description = "The ARN of the images S3 bucket"
}

output "images_bucket_cloudfront_domain" {
  value       = module.cdn.cloudfront_domain_name
  description = "The CloudFront domain for images"
}

output "images_bucket_cloudfront_arn" {
  value       = module.cdn.cloudfront_distribution_arn
  description = "The ARN of the CloudFront distribution for images"
}

# --- App Bucket Outputs ---
output "app_bucket_id" {
  value       = module.app_bucket.bucket_id
  description = "The S3 bucket ID for the app"
}

output "app_bucket_arn" {
  value       = module.app_bucket.bucket_arn
  description = "The ARN of the app S3 bucket"
}

output "app_bucket_cloudfront_domain" {
  value       = module.app_cdn.cloudfront_domain_name
  description = "The CloudFront domain for the app"
}

output "app_bucket_cloudfront_arn" {
  value       = module.app_cdn.cloudfront_distribution_arn
  description = "The ARN of the CloudFront distribution for the app"
}
