resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "aws_s3_bucket" "this" {
  bucket = "${var.bucket_name}-${random_string.suffix.result}"

  tags = {
    Name        = "${var.bucket_name}-${random_string.suffix.result}"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}



resource "aws_s3_object" "objects" {
  for_each = { for obj in var.objects : obj.key => obj }

  bucket = aws_s3_bucket.this.id
  key    = each.value.key
  source = each.value.source

  server_side_encryption = "AES256"

  content_type = lookup(
    {
      "html" = "text/html",
      "css"  = "text/css",
      "js"   = "application/javascript",
      "jpg"  = "image/jpeg",
      "jpeg" = "image/jpeg",
      "png"  = "image/png",
      "gif"  = "image/gif",
      "webp" = "image/webp"
    },
    split(".", each.value.key)[length(split(".", each.value.key)) - 1],
    "application/octet-stream"
  )
}


resource "aws_s3_bucket_policy" "cloudfront_access" {
  count  = var.enable_cloudfront && var.cloudfront_distribution_arn != "" ? 1 : 0
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = { Service = "cloudfront.amazonaws.com" }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.this.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = var.cloudfront_distribution_arn
          }
        }
      }
    ]
  })
}
