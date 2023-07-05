# Chapter 4. VPCs

## Labs

Done:
- Study Guide exercise 4.1 - Create VPC
- Study Guide exercise 4.2 - Create subnets
- Study Guide exercise 4.3 - Attach primary ENI to EC2 instance
- Study Guide exercise 4.4 - Create internet gateway and default route to it
- Study Guide exercise 4.5 - Create custom security group
- Study Guide exercise 4.6 - NACL to allow HTTP and HTTPS from any address
- Study Guide exercise 4.7 - Allocate an EIP and associate it with an ENI
- Study Guide exercise 4.8 - Create a transit gateway
- Study Guide exercise 4.9 - Create a blackhole route
- Does an instance's auto-assigned private IPv4 address get preserved after stopping and starting the instance?

TODO:
- [NAT instances](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_NAT_Instance.html#basics)
- AWS Cookbook exercise 2.6 - VPC Reachability Analyzer
- AWS Cookbook exercise 2.8 - Security group with prefix lists
- AWS Cookbook exercise 2.9 - VPC endpoints
- AWS Cookbook exercise 2.10 - AWS Transit Gateway to share internet gateway
- AWS Cookbook exercise 2.11 - VPC peering
- AWS Security section 6.2 - AWS Web Application Firewall v2
- NAT instances
- AWS PrivateLink
- AWS Site-to-Site VPN
- AWS Transit Gateway - isolated router
- AWS Transit Gateway - peering
- AWS Transit Gateway - multicast
- AWS Global Accelerator



## Running labs

1. Use a profile that sources temporary AWS credentials from AWS Single Sign-On:
    $ aws configure sso --profile <PROFILE_NAME>

    Where you choose the PowerUserAccess. This role has enough permissions whereas SystemAdministrator does not.
2. Export AWS profile:
    $ export AWS_PROFILE=<PROFILE_NAME>

3. Run Terraform plan or apply

## Network ACLs
When you create a VPC, a default NACL is created, where the default NACL allows all ingress and egress traffic.

However, in a manually created NACL, the NACL denies all ingress and egress traffic. That's regardless of whether you create the new NACL via Terraform or the AWS CLI. So, in a manually created NACL, if you want to allow inbound HTTP connections to port 80, you need to create both an ingress rule for HTTP requests and an egress rule for HTTP responses.

When you create a subnet, the subnet is associated with the VPC's default NACL. Later, you can associate the subnet with a NACL of your choice. However, during subnet creation, you are forced to associate the subnet with the default NACL. 

## Security groups

By default, all outbound traffic is allowed for security groups created through the AWS CLI but denied for security groups created through Terraform.

## Does an instance keep its auto-assigned private IPv4 address after stopped and started?

Yes.

How I tested:
1. Use alpha_vpc.tf to create the alpha_web_instance_2 instance that has an auto-assigned IPv4 address in the alpha_web_subnet_1 subnet.
2. Note that the auto-assigned private IPv4 address is 172.16.100.96.
3. Stop the instance.
4. Note that the same IPv4 address is still assigned to the stopped instance.
5. Start the instance.
6. Note that the same IPv4 address is still assigned to the running instance.
