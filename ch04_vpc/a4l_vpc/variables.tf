variable "a4l_vpc1_subnet_details" {
  description = "Details of each subnet of the a4l-vpc1 VPC"
  type        = map(any)

  default = {
    sn_reserved_a = {
      az          = "ap-southeast-2a"
      ipv4_cidr   = "10.16.0.0/20"
      ipv6_netnum = 0
      name        = "sn-reserved-A"
    }
    sn_db_a = {
      az          = "ap-southeast-2a"
      ipv4_cidr   = "10.16.16.0/20"
      ipv6_netnum = 1
      name        = "sb-db-A"
    }
    sn_app_a = {
      az          = "ap-southeast-2a"
      ipv4_cidr   = "10.16.32.0/20"
      ipv6_netnum = 2
      name        = "sn-app-A"
    }
    sn_web_a = {
      az          = "ap-southeast-2a"
      ipv4_cidr   = "10.16.48.0/20"
      ipv6_netnum = 3
      name        = "sn-web-A"
    }

    sn_reserved_b = {
      az          = "ap-southeast-2b"
      ipv4_cidr   = "10.16.64.0/20"
      ipv6_netnum = 4
      name        = "sn-reserved-B"
    }
    sn_db_b = {
      az          = "ap-southeast-2b"
      ipv4_cidr   = "10.16.80.0/20"
      ipv6_netnum = 5
      name        = "sn-db-B"
    }
    sn_app_b = {
      az          = "ap-southeast-2b"
      ipv4_cidr   = "10.16.96.0/20"
      ipv6_netnum = 6
      name        = "sn-app-B"
    }
    sn_web_b = {
      az          = "ap-southeast-2b"
      ipv4_cidr   = "10.16.112.0/20"
      ipv6_netnum = 7
      name        = "sn-web-B"
    }

    sn_reserved_c = {
      az          = "ap-southeast-2c"
      ipv4_cidr   = "10.16.128.0/20"
      ipv6_netnum = 8
      name        = "sn-reserved-C"
    }
    sn_db_c = {
      az          = "ap-southeast-2c"
      ipv4_cidr   = "10.16.144.0/20"
      ipv6_netnum = 9
      name        = "sn-db-C"
    }
    sn_app_c = {
      az          = "ap-southeast-2c"
      ipv4_cidr   = "10.16.160.0/20"
      ipv6_netnum = 10
      name        = "sn-app-C"
    }
    sn_web_c = {
      az          = "ap-southeast-2c"
      ipv4_cidr   = "10.16.176.0/20"
      ipv6_netnum = 11
      name        = "sn-web-C"
    }
  }
}

variable "a4l_vpc1_ipv6_netbits" {
  type    = number
  default = 8
}
