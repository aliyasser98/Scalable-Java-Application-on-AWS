resource "aws_vpc" "java_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "java-vpc-${var.environment}"
  }
}
resource "aws_subnet" "java_public_subnet" {
  count = length(var.public_subnet_cidrs)

  vpc_id            = aws_vpc.java_vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "java-public-subnet-${var.environment}-${count.index + 1}"
  }
}
resource "aws_internet_gateway" "java_igw" {
  vpc_id = aws_vpc.java_vpc.id

  tags = {
    Name = "java-igw-${var.environment}"
  }
  
}

resource "aws_route_table" "java_public_rt" {
  vpc_id = aws_vpc.java_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.java_igw.id
  }

  tags = {
    Name = "java-public-rt-${var.environment}"
  }
}
resource "aws_route_table_association" "java_public_rt_association" {
  count = length(var.public_subnet_cidrs)

  subnet_id      = aws_subnet.java_public_subnet[count.index].id
  route_table_id = aws_route_table.java_public_rt.id

}