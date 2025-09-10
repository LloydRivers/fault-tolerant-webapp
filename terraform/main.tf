# --- VPC (Virtual Private Cloud) ---
# Purpose: Logical network boundary for all resources
# Needs: CIDR block, public/private subnets, route tables, internet gateway
# Outputs: VPC ID, public subnet IDs, private subnet IDs
module "webapp_vpc" {
  source               = "./modules/vpc"
  vpc_name             = "webapp-vpc"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.2.0/24", "10.0.4.0/24"]
  availability_zones   = ["eu-west-2a", "eu-west-2b"]
}


# --- CloudFront Distribution (Optional) ---
# Purpose: Serve static assets (HTML, images) globally with low latency
# Needs: S3 bucket as origin, default root object, optional aliases
module "cdn" {
  source = "./modules/cloudfront"

  bucket_domain_name  = module.images_bucket.bucket_regional_domain_name
  aliases             = []
  default_root_object = "index.html"
  enabled             = true
}

# --- S3 Bucket for Static Assets ---
# Purpose: Store images and other static content for the app
# Needs: Unique bucket name, optional CloudFront integration
# Outputs: Bucket ARN, regional domain name
module "images_bucket" {
  source            = "./modules/s3"
  bucket_name       = "my-fault-tolerant-app-images-bucket"
  enable_cloudfront = true

  objects = [
    { key = "uploads/user-avatar-123.jpg", source = "app/assets/images/user-avatar-123.png" },
    { key = "uploads/product-photo-456.png", source = "app/assets/images/product-photo-456.png" },
    { key = "uploads/banner-image-789.webp", source = "app/assets/images/banner-image-789.png" }
  ]
}

# --- IAM Policy Document for CloudFront → S3 Access ---
# Purpose: Allow CloudFront distribution to fetch objects from S3 securely
data "aws_iam_policy_document" "cloudfront_s3_access" {
  statement {
    sid    = "AllowCloudFrontServicePrincipal"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = ["s3:GetObject"]

    resources = ["${module.images_bucket.bucket_arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [module.cdn.cloudfront_distribution_arn]
    }
  }
}

# --- Bucket Policy ---
# Purpose: Attach the IAM policy to the S3 bucket so CloudFront can read objects
resource "aws_s3_bucket_policy" "cloudfront_access" {
  bucket = module.images_bucket.bucket_id
  policy = data.aws_iam_policy_document.cloudfront_s3_access.json
}

# --- Web EC2 Instances + Auto Scaling ---
# Purpose: Launch and scale EC2 web servers in private subnets
# Needs: VPC ID, private subnets, security groups, target group ARN from ALB
module "web_ec2" {
  source             = "./modules/ec2"
  vpc_id             = module.webapp_vpc.vpc_id
  private_subnet_ids = module.webapp_vpc.private_subnets
  alb_sg_id          = module.alb.alb_sg_id
  target_group_arn   = module.alb.target_group_arn
  ami                = "ami-067d8bdd95a24359f"
  instance_type      = "t3.micro"
  key_name           = "secret-key" # SSH key pair for EC2
  desired_capacity   = 1
  min_size           = 1
  max_size           = 2
}

# --- Application Load Balancer ---
# Purpose: Distribute HTTP traffic to web EC2 instances for high availability
# Needs: Public subnets, security group, target group, listener
# Outputs: ALB ARN, security group ID, target group ARN
module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.webapp_vpc.vpc_id
  public_subnet_ids = module.webapp_vpc.public_subnets
}
