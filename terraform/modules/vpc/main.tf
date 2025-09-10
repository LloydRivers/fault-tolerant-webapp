resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = { Name = var.vpc_name }
}

# --- 2a. Public Subnets ---
# Purpose: Subnets that have direct internet access.
# Used by: ALBs, NAT gateways, any publicly facing service.
# Needs:
#   - CIDR blocks within the VPC
#   - Availability zones (for high availability)
#   - Association with public route table (done later)
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = { Name = "${var.vpc_name}-public-${count.index + 1}" }
}

# --- 2b. Private Subnets ---
# Purpose: Subnets without direct internet access; used for EC2 application servers.
# Needs:
#   - CIDR blocks within the VPC
#   - Availability zones for HA
# Access:
#   - Outbound traffic via NAT gateway (not shown here, optional)
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = { Name = "${var.vpc_name}-private-${count.index + 1}" }
}

# --- 3. Internet Gateway (IGW) ---
# Purpose: Connect the public subnets to the internet.
# Needed for:
#   - Public ALB to receive traffic
#   - Optional NAT gateway for private subnet outbound
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = { Name = "${var.vpc_name}-igw" }
}

# --- 4. Public Route Table ---
# Purpose: Defines how traffic exits the public subnets.
# Needs:
#   - IGW ID as default route for 0.0.0.0/0
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = { Name = "${var.vpc_name}-public-rt" }
}

# --- 5. Route Table Association for Public Subnets ---
# Purpose: Attach public subnets to the public route table so they can reach the internet.
# Needs:
#   - Each public subnet ID
#   - Public route table ID
resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  tags = { Name = "${var.vpc_name}-nat-eip" }
} 

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id  

  tags = { Name = "${var.vpc_name}-nat-gateway" }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = { Name = "${var.vpc_name}-private-rt" }
}

resource "aws_route_table_association" "private_assoc" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

