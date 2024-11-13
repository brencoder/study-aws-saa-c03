resource "aws_vpc" "a4l_vpc1" {
  assign_generated_ipv6_cidr_block = true
  cidr_block                       = "10.16.0.0/16"
  enable_dns_hostnames             = true
  enable_dns_support               = true
  instance_tenancy                 = "default"
  tags = {
    Name    = "a4l-vpc1",
    Brendon = ""
  }
}
