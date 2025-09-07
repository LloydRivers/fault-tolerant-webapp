resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = { Name = var.vpc_name }
}

resource "aws_subnet" "this" {
  count             = length(var.subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = { Name = "${var.vpc_name}-subnet-${count.index + 1}" }
}

