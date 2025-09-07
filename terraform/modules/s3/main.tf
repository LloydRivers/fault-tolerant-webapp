resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = "dev"
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "objects" {
  for_each = { for obj in var.objects : obj.key => obj }

  bucket = aws_s3_bucket.this.id
  key    = each.value.key
  source = each.value.source

  # Optional: enable server-side encryption
  server_side_encryption = "AES256"
}

output "bucket_name" {
  value = aws_s3_bucket.this.id
}

output "object_versions" {
  value = { for k, obj in aws_s3_object.objects : k => obj.version_id }
}
