output "bucket_id" {
  description = "The bucket name"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "The bucket ARN"
  value       = aws_s3_bucket.this.arn
}

output "bucket_regional_domain_name" {
  description = "The regional domain name of the bucket"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "object_versions" {
  description = "Version IDs of uploaded objects"
  value = { for k, obj in aws_s3_object.objects : k => obj.version_id }
}
