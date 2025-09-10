# --- S3 Bucket for Images ---
module "images_bucket" {
  source      = "./modules/s3/images"
  bucket_name = "my-fault-tolerant-app-images-bucket"

  objects = [
    { key = "uploads/user-avatar-123.jpg", source = "app/assets/images/user-avatar-123.png" },
    { key = "uploads/product-photo-456.png", source = "app/assets/images/product-photo-456.png" },
    { key = "uploads/banner-image-789.webp", source = "app/assets/images/banner-image-789.png" }
  ]
}

# --- CloudFront Distribution for Images ---
module "cdn" {
  source = "./modules/cloudfront/images"

  bucket_domain_name  = module.images_bucket.bucket_regional_domain_name
  default_root_object = "index.html"
  enabled             = true
}

# --- IAM Policy Document: CloudFront → Images S3 Access ---
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

# --- Attach Images Bucket Policy ---
resource "aws_s3_bucket_policy" "cloudfront_access" {
  bucket = module.images_bucket.bucket_id
  policy = data.aws_iam_policy_document.cloudfront_s3_access.json
}

# --- S3 Bucket for App ---
module "app_bucket" {
  source            = "./modules/app/s3"
  bucket_name       = "my-fault-tolerant-app-static-bucket"
  enable_cloudfront = true

  objects = [
    { key = "index.html", source = "app/dist/index.html" },
    { key = "styles.css", source = "app/dist/styles.css" },
    { key = "app.js", source = "app/dist/app.js" }
  ]
}

# --- CloudFront Distribution for App ---
module "app_cdn" {
  source = "./modules/cloudfront/app"

  bucket_domain_name  = module.app_bucket.bucket_regional_domain_name
  default_root_object = "index.html"
  enabled             = true
}

# --- IAM Policy Document: CloudFront → App S3 Access ---
data "aws_iam_policy_document" "app_cloudfront_s3_access" {
  statement {
    sid    = "AllowCloudFrontServicePrincipal"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions   = ["s3:GetObject"]
    resources = ["${module.app_bucket.bucket_arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [module.app_cdn.cloudfront_distribution_arn]
    }
  }
}

# --- Attach App Bucket Policy ---
resource "aws_s3_bucket_policy" "app_cloudfront_access" {
  bucket = module.app_bucket.bucket_id
  policy = data.aws_iam_policy_document.app_cloudfront_s3_access.json
}
