# Chapter 4. VPCs

For an introduction, see [How Amazon VPC works](https://docs.aws.amazon.com/vpc/latest/userguide/how-it-works.html).

## Network ACLs

A network ACL controls traffic in and out of a subnet.

The default network ACL allows all traffic in and out of a subnet. When you create a VPC, a default NACL is created for the new VPC. When you create a subnet, the subnet is associated with the VPC's default NACL. Later, you can associate the subnet with a NACL of your choice. However, during subnet creation, you are forced to associate the subnet with the default NACL.

If you create a custom ACL, then it denies all traffic until you specify which traffic should be allowed. That's regardless of whether you create the new NACL via Terraform or the AWS CLI. So, in a manually created NACL, if you want to allow inbound HTTP connections to port 80, you need to create both an ingress rule for HTTP requests and an egress rule for HTTP responses.

A network ACL is stateless and remember nothing. So, if a request is allowed in by a network ACL, the response won't be allowed out unless explicitly permitted by the network ACL.

![A network ACL is stateless](nacl_is_stateless.png "A NACL is stateless")

Analogy: A network ACL is to a subnet what a passport control officer is to an airport

However, network ACLs do not control traffic within a subnet; that is where security groups come in.

## Security groups

By default, all outbound traffic is allowed for security groups created through the AWS CLI but denied for security groups created through Terraform.

## Internet gateways

An internet gateway is not just for connections from your VPC to the Internet. An internet gateway is also required for connections in the other direction, that is, from the Internet to your VPC.

![An internet gateway is required for connections from the Internet to your VPC](internet_to_vpc.png "Connections from the Internet to your VPC")

## Virtual Private Gateways

Like an internet gateway, but allows and denies connections from a corporate network rather than the entire Internet. Also, connections to and from a VPG are encrypted.

## Direct Connect

A dedicated, independent, physical connection between an on-premises data centre and a VPC.

## Amazon API Gateway

Fully managed service that enables you to create, publish, maintain, monitor and secure RESTful APIs and WebSocket APIs.

Handles traffic management, authorisation, access control, throttling, monitoring and API version management

Amazon API Gateway sends the API requests to a compute platform of your choice, e.g., AWS Lambda, Amazon EC2, Amazon Kinesis, other AWS services, applications in your VPC and applications on-premises.

Pricing for HTTPS and REST APIs is based on the number of API calls received and amount of data transferred out.

Pricing for WebSocket APIs is based on the duration of connections between clients, and how many messages are sent between clients.

For more info:
* [Amazon API Gateway Overview](https://aws.amazon.com/api-gateway/)
* [Amazon API Gateway Resources](https://aws.amazon.com/api-gateway/resources/)

Amazon API Gateway logs to Amazon CloudWatch

## AWS Firewall Manager

Centrally manage firewall rules across the accounts of your AWS Organizations structure.

Types of firewall rules supported are:
* SGs
* AWS WAF
* AWS Network Firewall
* AWS Shield
* Amazon Route 53 Resolver DNS Firewall
* Third-party firewall

## AWS Network Firewall

Fully managed firewall that controls traffic entering/leaving the or VPCs or VPC subnets of an AWS account.

Can work with Direct Connect and VPN traffic too.

Can use stateful inspection and protocol inspection.

Although AWS Network Firewall settings of an AWS account apply to only to the same account, you can use AWS Firewall Manager to centrally configure the AWS Netwok Firewalls of multiple accounts.

## Does an instance keep its auto-assigned private IPv4 address after stopped and started?

Yes.

How I tested:
1. Use alpha_vpc.tf to create the alpha_web_instance_2 instance that has an auto-assigned IPv4 address in the alpha_web_subnet_1 subnet.
2. Note that the auto-assigned private IPv4 address is 172.16.100.96.
3. Stop the instance.
4. Note that the same IPv4 address is still assigned to the stopped instance.
5. Start the instance.
6. Note that the same IPv4 address is still assigned to the running instance.

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

TODO more VPC labs:
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
