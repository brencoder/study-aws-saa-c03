variable "a4l_vpc1_subnet_details" {
  description = "Details of each subnet of the a4l-vpc1 VPC"
  type        = map(any)

  default = {
    reserved_a = {
      az          = "ap-southeast-2a"
      ipv4_cidr   = "10.16.0.0/20"
      ipv6_netnum = 0
      name        = "sn-reserved-A"
    }
  }
}

variable "a4l_vpc1_ipv6_netbits" {
  type    = number
  default = 8
}
