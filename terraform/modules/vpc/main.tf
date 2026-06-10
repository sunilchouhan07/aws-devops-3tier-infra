
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name        = "${var.env}-vpc"
    Environment = var.env
  }
}

resource "aws_subnet" "public_sub" {
  for_each = var.public_subnets
  vpc_id   = aws_vpc.vpc.id

  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  map_public_ip_on_launch = true


  tags = {
    Name        = "${var.env}-${each.key}"
    Environment = var.env
  }
}

resource "aws_subnet" "private_sub_app" {
  for_each = var.private_subnets_app
  vpc_id   = aws_vpc.vpc.id

  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name        = "${var.env}-${each.key}"
    Environment = var.env
  }
}

resource "aws_subnet" "private_sub_rds" {
  for_each = var.private_subnets_rds
  vpc_id   = aws_vpc.vpc.id

  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name        = "${var.env}-${each.key}"
    Environment = var.env
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}


resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name        = "${var.env}-nat-eip"
    Environment = var.env
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_sub[var.nat_subnet_name].id

  tags = {
    Name        = "${var.env}-ngw"
    Environment = var.env
  }

  depends_on = [aws_internet_gateway.igw]
}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name        = "${var.env}-pub-rt"
    Environment = var.env
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name        = "${var.env}-pri-rt"
    Environment = var.env
  }
}

resource "aws_route_table_association" "public_rt_ass" {
  for_each       = aws_subnet.public_sub
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id

}

resource "aws_route_table_association" "private_rt_ass" {
  for_each       = aws_subnet.private_sub_app
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}
