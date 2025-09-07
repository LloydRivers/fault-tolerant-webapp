module "webapp_vpc" {
  source = "./modules/vpc"

  vpc_cidr           = "10.0.0.0/16"
  subnet_cidrs       = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones = ["eu-west-2a", "eu-west-2b"]
  vpc_name           = "webapp-vpc"
}

module "images_bucket" {
  source      = "./modules/s3"
  bucket_name = "my-fault-tolerant-app-images-bucket"

  objects = [
    {
      key    = "uploads/user-avatar-123.jpg"
      source = "app/assets/images/user-avatar-123.png"
    },
    {
      key    = "uploads/product-photo-456.png"
      source = "app/assets/images/product-photo-456.png"
    },
    {
      key    = "uploads/banner-image-789.webp"
      source = "app/assets/images/banner-image-789.png"
    }
  ]
}
