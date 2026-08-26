resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true // expose DNS instead of an IP address

  tags = merge(
    local.tags,
    {
      Name = "Main VPC"
    }
  )
}

// Create the internet gateway
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(
    local.tags,
    {
      Name = "Main IGW"
    }
  )
}

// Create the EIP for the Nat Gateway
resource "aws_eip" "nat_gateway_eip" {
  domain = "vpc"

  depends_on = [aws_internet_gateway.vpc_igw]

  tags = merge(
    local.tags,
    {
      Name = "EIP IGW"
    }
  )
}

// Create the Nat gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.public_subnets["public-subnet-1"].id # nat should be in public subnet

  depends_on = [aws_subnet.public_subnets]

  tags = merge(
    local.tags,
    {
      Name = "NAT Gateway"
    }
  )
}

# Create route tables for public subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"                     # all IP addresses
    gateway_id = aws_internet_gateway.vpc_igw.id # IPs addresses routed over the IGW
  }

  depends_on = [aws_internet_gateway.vpc_igw]

  tags = merge(
    local.tags,
    {
      Name = "Public Route Table"
    }
  )
}

# Create a single route table for all private subnets
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = merge(
    local.tags,
    {
      Name = "Private route table"
    }
  )
}

# Create route table associations
resource "aws_route_table_association" "rt_public" {
  for_each = aws_subnet.public_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id

  depends_on = [aws_subnet.public_subnets]
}

resource "aws_route_table_association" "rt_private" {
  for_each = aws_subnet.private_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id

  depends_on = [aws_subnet.private_subnets]
}

// Create the Public Subnets
resource "aws_subnet" "public_subnets" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 100 + each.value)
  availability_zone       = tolist(data.aws_availability_zones.available.names)[each.value]
  map_public_ip_on_launch = true

  tags = merge(
    local.tags,
    {
      Name                     = each.key
      "kubernetes.io/role/elb" = 1
    }
  )
}

// Create the Private Subnets
resource "aws_subnet" "private_subnets" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 200 + each.value)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]

  tags = merge(
    local.tags,
    {
      Name                              = each.key
      "kubernetes.io/role/internal-elb" = 1
    }
  )
}
