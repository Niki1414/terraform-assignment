# VPC
resource "aws_vpc" "terra_vpc" {
  cidr_block = "${var.vpc_cidr}"
  tags = {
    Name = "TerraVPC"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "terra_igw" {
  vpc_id = "${aws_vpc.terra_vpc.id}"
  tags = {
    Name = "main"
  }
}

# Subnets : public
resource "aws_subnet" "public" {
  count                   = "${length(var.public_subnets_cidr)}"
  vpc_id                  = "${aws_vpc.terra_vpc.id}"
  cidr_block              = "${element(var.public_subnets_cidr, count.index)}"
  availability_zone       = "${element(var.azs, count.index)}"
  map_public_ip_on_launch = true
  tags = {
    Name = "Subnet-public-${element(var.azs, count.index)}"
  }
}

# Subnets : private
resource "aws_subnet" "private" {
  count             = "${length(var.private_subnet_cidr)}"
  vpc_id            = "${aws_vpc.terra_vpc.id}"
  cidr_block        = "${element(var.private_subnet_cidr, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"
  #  map_public_ip_on_launch = true
  tags = {
    Name = "Subnet-private-${element(var.azs, count.index)}"
}
}

# Route table: attach Internet Gateway
resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.terra_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.terra_igw.id}"
  }
  tags = {
    Name = "publicRouteTable"
  }
}

# Route table association with public subnets
resource "aws_route_table_association" "a" {
  count          = "${length(var.public_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_rt.id}"
}


/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.terra_igw]
}
/* NAT */
resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = "${element(aws_subnet.public.*.id, 0)}"
  depends_on    = [aws_internet_gateway.terra_igw]
  tags = {
    Name = "nat"
  }
}

# Route table: attach NAT Gateway
resource "aws_route_table" "private_rt" {
  vpc_id = "${aws_vpc.terra_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat.id}"
  }
  tags = {
    Name = "privateRouteTable"
  }
}

# Route table association with private subnets
resource "aws_route_table_association" "private_association" {
  count          = "${length(var.private_subnet_cidr)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private_rt.id}"
}
