resource "aws_vpc" "gamma_vpc" {
  cidr_block = "172.18.0.0/16"

  tags = {
    Creator = "BK"
    Name = "gamma_vpc"
  }
}

resource "aws_vpc" "delta_vpc" {
  cidr_block = "172.19.0.0/16"

  tags = {
    Creator = "BK"
    Name = "delta_vpc"
  }
}

resource "aws_vpc_peering_connection" "gamma_requesting_delta" {
  vpc_id = aws_vpc.gamma_vpc.id
  peer_vpc_id = aws_vpc.delta_vpc.id

  tags = {
    Creator = "BK"
    Name = "gamma_requesting_delta"
  }
}

resource "aws_vpc_peering_connection_accepter" "delta_accepting_gamma" {
  vpc_peering_connection_id = aws_vpc_peering_connection.gamma_requesting_delta.id
  auto_accept = true

  tags = {
    Creator = "BK"
    Name = "delta_accepting_gamma"
  }
}

resource "aws_default_route_table" "gamma_main_route_table" {
  default_route_table_id = aws_vpc.gamma_vpc.default_route_table_id
  
  route {
    cidr_block = aws_vpc.delta_vpc.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.gamma_requesting_delta.id
  }

  tags = {
    Creator = "BK"
    Name = "gamma_main_route_table"
  }
}

resource "aws_default_route_table" "delta_main_route_table" {
  default_route_table_id = aws_vpc.delta_vpc.default_route_table_id
  
  route {
    cidr_block = aws_vpc.gamma_vpc.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.gamma_requesting_delta.id
  }

  tags = {
    Creator = "BK"
    Name = "delta_main_route_table"
  }
}
