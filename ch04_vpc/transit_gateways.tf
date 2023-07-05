# --- Start Study Guide exercise 4.8 ---
# Create a transit gateway

resource "aws_ec2_transit_gateway" "centralised_router" {
  description = "AWS Transit Gateway to act as a centralised router between a number of VPCs"

  tags = {
    Creator = "BK"
    Name = "centralised_router"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "centralised_router_to_alpha_private_subnets" {
  transit_gateway_id = aws_ec2_transit_gateway.centralised_router.id
  vpc_id = aws_vpc.alpha_vpc.id
  subnet_ids = [
    aws_subnet.alpha_private_subnet_1.id,
    aws_subnet.alpha_private_subnet_2.id
  ]

  tags = {
    Creator = "BK"
    Name = "centralised_router_to_alpha_private_subnets"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "centralised_router_to_beta_private_subnets" {
  transit_gateway_id = aws_ec2_transit_gateway.centralised_router.id
  vpc_id = aws_vpc.beta_vpc.id
  subnet_ids = [
    aws_subnet.beta_private_subnet_1.id,
    aws_subnet.beta_private_subnet_2.id
  ]

  tags = {
    Creator = "BK"
    Name = "centralised_router_to_beta_private_subnets"
  }
}

# --- End Study Guide exercise 4.8 ---

# --- Start Study Guide exercise 4.9 ---
# Create a blackhole route

data "aws_ec2_transit_gateway_route_table" "centralised_router_default_route_table" {
  filter {
    name   = "default-association-route-table"
    values = ["true"]
  }

  filter {
    name   = "transit-gateway-id"
    values = [aws_ec2_transit_gateway.centralised_router.id]
  }
}

resource "aws_ec2_transit_gateway_route" "blackhole" {
  destination_cidr_block = "172.16.100.64/29"
  blackhole = true
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.centralised_router_default_route_table.id
}

# --- End Study Guide exercise 4.9 ---
