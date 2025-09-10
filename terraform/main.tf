# --- S3 Bucket for Static Assets ---
module "images_bucket" {
  source      = "./modules/s3/images"
  bucket_name = "my-fault-tolerant-app-images-bucket"

  objects = [
    { key = "uploads/user-avatar-123.jpg", source = "app/assets/images/user-avatar-123.png" },
    { key = "uploads/product-photo-456.png", source = "app/assets/images/product-photo-456.png" },
    { key = "uploads/banner-image-789.webp", source = "app/assets/images/banner-image-789.png" }
  ]
}

# --- CloudFront Distribution ---
module "cdn" {
  source = "./modules/cloudfront"

  bucket_domain_name  = module.images_bucket.bucket_regional_domain_name
  default_root_object = "index.html"
  enabled             = true
}

# --- IAM Policy Document: CloudFront → S3 Access ---
data "aws_iam_policy_document" "cloudfront_s3_access" {
  statement {
    sid    = "AllowCloudFrontServicePrincipal"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions   = ["s3:GetObject"]
    resources = ["${module.images_bucket.bucket_arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [module.cdn.cloudfront_distribution_arn]
    }
  }
}

# --- Attach Bucket Policy ---
resource "aws_s3_bucket_policy" "cloudfront_access" {
  bucket = module.images_bucket.bucket_id
  policy = data.aws_iam_policy_document.cloudfront_s3_access.json
}
