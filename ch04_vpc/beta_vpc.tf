resource "aws_vpc" "beta_vpc" {
  cidr_block = "172.17.0.0/16"

  tags = {
    Creator = "BK"
    Name = "beta_vpc"
  }
}

resource "aws_subnet" "beta_private_subnet_1" {
  vpc_id = aws_vpc.beta_vpc.id
  cidr_block = "172.17.101.0/24"
  availability_zone = "ap-southeast-2a"

  tags = {
    Creator = "BK"
    Name = "beta_private_subnet_1"
  }
}

resource "aws_subnet" "beta_private_subnet_2" {
  vpc_id = aws_vpc.beta_vpc.id
  cidr_block = "172.17.201.0/24"
  availability_zone = "ap-southeast-2b"

  tags = {
    Creator = "BK"
    Name = "beta_private_subnet_2"
  }
}

resource "aws_route_table" "beta_private_route_table" {
  vpc_id = aws_vpc.beta_vpc.id

  tags = {
    Creator = "BK"
    Name = "beta_private_route_table"
  }
}

resource "aws_route_table_association" "beta_private_subnet_1_route_table_assocation" {
  route_table_id = aws_route_table.beta_private_route_table.id
  subnet_id = aws_subnet.beta_private_subnet_1.id
}

resource "aws_route_table_association" "beta_private_subnet_2_route_table_assocation" {
  route_table_id = aws_route_table.beta_private_route_table.id
  subnet_id = aws_subnet.beta_private_subnet_2.id
}

resource "aws_route" "beta_private_route_to_alpha_private_subnet_1" {
  route_table_id = aws_route_table.beta_private_route_table.id
  destination_cidr_block = aws_subnet.alpha_private_subnet_1.cidr_block
  transit_gateway_id = aws_ec2_transit_gateway.centralised_router.id
}

resource "aws_route" "beta_private_route_to_alpha_private_subnet_2" {
  route_table_id = aws_route_table.beta_private_route_table.id
  destination_cidr_block = aws_subnet.alpha_private_subnet_2.cidr_block
  transit_gateway_id = aws_ec2_transit_gateway.centralised_router.id
}

