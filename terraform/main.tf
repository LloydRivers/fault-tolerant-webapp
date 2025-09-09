module "webapp_vpc" {
  source = "./modules/vpc"
  vpc_cidr           = "10.0.0.0/16"
  subnet_cidrs       = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones = ["eu-west-2a", "eu-west-2b"]
  vpc_name           = "webapp-vpc"
}

module "cdn" {
  source = "./modules/cloudfront"

  bucket_domain_name  = module.images_bucket.bucket_regional_domain_name
  aliases             = []
  default_root_object = "index.html"
  enabled             = true
}

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

data "aws_iam_policy_document" "cloudfront_s3_access" {
  statement {
    sid    = "AllowCloudFrontServicePrincipal"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${module.images_bucket.bucket_arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [module.cdn.cloudfront_distribution_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudfront_access" {
  bucket = module.images_bucket.bucket_id
  policy = data.aws_iam_policy_document.cloudfront_s3_access.json
}

module "web_ec2" {
  source              = "./modules/ec2"
  vpc_id              = module.webapp_vpc.vpc_id
  private_subnet_ids  = module.webapp_vpc.private_subnets
  alb_sg_id           = module.alb.alb_sg_id
  target_group_arn    = module.alb.target_group_arn 
  ami                 = "ami-0c101f26f147fa7fd"
  instance_type       = "t3.micro"
  key_name            = "secret-key"
  desired_capacity    = 1
  min_size            = 1
  max_size            = 2
}

module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.webapp_vpc.vpc_id
  public_subnet_ids = module.webapp_vpc.public_subnets
  instance_ids      = [module.ec2.instance_id]  
}


