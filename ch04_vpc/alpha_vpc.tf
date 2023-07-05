# --- Start Study Guide exercise 4.1 ---
# Create VPC

resource "aws_vpc" "alpha_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Creator = "BK"
    Name = "alpha_vpc"
  }
}

# --- End Study Guide exercise 4.1 ---

# -------------------------------------------
# Public VPC resources
# -------------------------------------------

# --- Start Study Guide exercise 4.2 ---
# Create subnets

resource "aws_subnet" "alpha_web_subnet_1" {
  vpc_id = aws_vpc.alpha_vpc.id
  cidr_block = "172.16.100.0/24"
  availability_zone = "ap-southeast-2a"

  tags = {
    Creator = "BK"
    Name = "alpha_web_subnet_1"
  }
}

resource "aws_subnet" "alpha_web_subnet_2" {
  vpc_id = aws_vpc.alpha_vpc.id
  cidr_block = "172.16.200.0/24"
  availability_zone = "ap-southeast-2b"

  tags = {
    Creator = "BK"
    Name = "alpha_web_subnet_2"
  }
}

# --- End Study Guide exercise 4.2 ---

# --- Start Study Guide exercise 4.3 ---
# Attach primary ENI to EC2 instance

resource "aws_network_interface" "alpha_web_instance_1_primary_eni" {
  subnet_id = aws_subnet.alpha_web_subnet_1.id
  private_ips = ["172.16.100.10"]
  security_groups = [aws_security_group.alpha_web_security_group.id]

  tags = {
    Creator = "BK"
    Name = "alpha_web_instance_1_primary_eni"
  }
}

resource "aws_instance" "alpha_web_instance_1" {
  ami = data.aws_ami.latest_ubuntu_20_04.id
  instance_type = "t2.micro"

  network_interface {
      device_index = 0
      network_interface_id = aws_network_interface.alpha_web_instance_1_primary_eni.id
  }

  # Note: I can't specify 'vpc_security_group_ids'
  # because I inherit the SGs of my network interfaces

  tags = {
    Creator = "BK"
    Name = "alpha_web_instance_1"
  }
}

# --- End Study Guide exercise 4.3 ---

# --- Start Study Guide exercise 4.4 ---
# Create internet gateway and default route to it

resource "aws_internet_gateway" "alpha_web_internet_gateway" {
  vpc_id = aws_vpc.alpha_vpc.id

  tags = {
    Creator = "BK"
    Name = "alpha_web_internet_gateway"
  }
}

resource "aws_route_table" "alpha_web_route_table" {
  vpc_id = aws_vpc.alpha_vpc.id

  tags = {
    Creator = "BK"
    Name = "alpha_web_route_table"
  }
}

resource "aws_route" "alpha_web_route_default" {
  route_table_id = aws_route_table.alpha_web_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.alpha_web_internet_gateway.id
}

resource "aws_route_table_association" "alpha_web_subnet_1_route_table_assocation" {
  route_table_id = aws_route_table.alpha_web_route_table.id
  subnet_id = aws_subnet.alpha_web_subnet_1.id
}

resource "aws_route_table_association" "alpha_web_subnet_2_route_table_assocation" {
  route_table_id = aws_route_table.alpha_web_route_table.id
  subnet_id = aws_subnet.alpha_web_subnet_2.id
}

# --- End Study Guide exercise 4.4 ---

resource "aws_eip" "eip_for_nat_gateway" {
  domain = "vpc"

  tags = {
    Creator = "BK"
    Name = "eip_for_nat_gateway"
  }
}

resource "aws_nat_gateway" "alpha_web_subnet_1_nat_gateway" {
  allocation_id = aws_eip.eip_for_nat_gateway.id
  subnet_id = aws_subnet.alpha_web_subnet_1.id
  connectivity_type = "public"

  tags = {
    Creator = "BK"
    Name = "alpha_web_subnet_1_nat_gateway"
  }
}

# --- Start Study Guide exercise 4.5 ---
# Create custom security group

resource "aws_security_group" "alpha_web_security_group" {
  vpc_id = aws_vpc.alpha_vpc.id
  name = "alpha_web_security_group"
  description = "Allow inbound HTTP and HTTPS traffic"

  tags = {
    Creator = "BK"
    Name = "alpha_web_security_group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alpha_web_security_group_allow_inbound_http" {
  security_group_id = aws_security_group.alpha_web_security_group.id
  description = "Allow inbound HTTP traffic"
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"

  tags = {
    Creator = "BK"
    Name = "alpha_web_security_group_allow_inbound_http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alpha_web_security_group_allow_inbound_https" {
  security_group_id = aws_security_group.alpha_web_security_group.id
  description = "Allow inbound HTTPS traffic"
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  to_port = 443
  ip_protocol = "tcp"

  tags = {
    Creator = "BK"
    Name = "alpha_web_security_group_allow_inbound_https"
  }
}

# --- End Study Guide exercise 4.5 ---

# --- Start Study Guide exercise 4.6 ---
# NACL to allow HTTP and HTTPS from any address

resource "aws_network_acl" "alpha_web_network_acl" {
  vpc_id = aws_vpc.alpha_vpc.id
  subnet_ids = [
    aws_subnet.alpha_web_subnet_1.id,
    aws_subnet.alpha_web_subnet_2.id
  ]

  tags = {
    Creator = "BK"
    Name = "alpha_web_network_acl"
  }
}

resource "aws_network_acl_rule" "alpha_web_network_acl_allow_inbound_http" {
  network_acl_id = aws_network_acl.alpha_web_network_acl.id
  rule_number = 50
  egress = false
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = 80
  to_port = 80
}

resource "aws_network_acl_rule" "alpha_web_network_acl_allow_inbound_https" {
  network_acl_id = aws_network_acl.alpha_web_network_acl.id
  rule_number = 60
  egress = false
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = 443
  to_port = 443
}

resource "aws_network_acl_rule" "alpha_web_network_acl_allow_outbound_tcp" {
  network_acl_id = aws_network_acl.alpha_web_network_acl.id
  rule_number = 100
  egress = true
  protocol = "tcp"
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
}

# --- End Study Guide exercise 4.6 ---

# --- Start Study Guide exercise 4.7 ---
# Allocate an EIP and associate it with an ENI

resource "aws_eip" "alpha_web_instance_1_primary_eni_eip" {
  domain = "vpc"

  # Could have used the network_interface argument,
  # but to learn more I will use aws_eip_association.

  tags = {
    Creator = "BK"
    Name = "alpha_web_instance_1_primary_eni_eip"
  }
}

resource "aws_eip_association" "alpha_web_instance_1_primary_eni_eip_association" {
  allocation_id = aws_eip.alpha_web_instance_1_primary_eni_eip.id
  network_interface_id = aws_network_interface.alpha_web_instance_1_primary_eni.id
}

# --- End Study Guide exercise 4.7 ---

# -------------------------------------------
# Private VPC resources
# -------------------------------------------

resource "aws_subnet" "alpha_private_subnet_1" {
  vpc_id = aws_vpc.alpha_vpc.id
  cidr_block = "172.16.101.0/24"
  availability_zone = "ap-southeast-2a"

  tags = {
    Creator = "BK"
    Name = "alpha_private_subnet_1"
  }
}

resource "aws_subnet" "alpha_private_subnet_2" {
  vpc_id = aws_vpc.alpha_vpc.id
  cidr_block = "172.16.201.0/24"
  availability_zone = "ap-southeast-2b"

  tags = {
    Creator = "BK"
    Name = "alpha_private_subnet_2"
  }
}

resource "aws_route_table" "alpha_private_route_table" {
  vpc_id = aws_vpc.alpha_vpc.id

  tags = {
    Creator = "BK"
    Name = "alpha_private_route_table"
  }
}

resource "aws_route" "alpha_private_route_to_beta_private_subnet_1" {
  route_table_id = aws_route_table.alpha_private_route_table.id
  destination_cidr_block = aws_subnet.beta_private_subnet_1.cidr_block
  transit_gateway_id = aws_ec2_transit_gateway.centralised_router.id
}

resource "aws_route" "alpha_private_route_to_beta_private_subnet_2" {
  route_table_id = aws_route_table.alpha_private_route_table.id
  destination_cidr_block = aws_subnet.beta_private_subnet_2.cidr_block
  transit_gateway_id = aws_ec2_transit_gateway.centralised_router.id
}

resource "aws_route" "alpha_private_route_default" {
  route_table_id = aws_route_table.alpha_private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.alpha_web_subnet_1_nat_gateway.id
}

resource "aws_route_table_association" "alpha_private_subnet_1_route_table_assocation" {
  route_table_id = aws_route_table.alpha_private_route_table.id
  subnet_id = aws_subnet.alpha_private_subnet_1.id
}

resource "aws_route_table_association" "alpha_private_subnet_2_route_table_assocation" {
  route_table_id = aws_route_table.alpha_private_route_table.id
  subnet_id = aws_subnet.alpha_private_subnet_2.id
}

# -------------------------------------------
# Test whether an instance keeps its auto-assigned private IPv4 address after being stopped and started
# -------------------------------------------
resource "aws_instance" "alpha_web_instance_2" {
  ami = data.aws_ami.latest_ubuntu_20_04.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.alpha_web_subnet_1.id
  vpc_security_group_ids = [aws_security_group.alpha_web_security_group.id]

  tags = {
    Creator = "BK"
    Name = "alpha_web_instance_2"
  }
}
