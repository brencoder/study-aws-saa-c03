resource "aws_subnet" "a4l_vpc1_subnets" {
  for_each = var.a4l_vpc1_subnet_details

  availability_zone = each.value.az
  cidr_block        = each.value.ipv4_cidr
  ipv6_cidr_block   = cidrsubnet(aws_vpc.a4l_vpc1.ipv6_cidr_block, var.a4l_vpc1_ipv6_netbits, each.value.ipv6_netnum)
  tags = {
    Brendon = "",
    Name    = each.value.name
  }
  vpc_id = aws_vpc.a4l_vpc1.id
}
