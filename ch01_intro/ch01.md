# Chapter 1 - Intro to AWS

## Interesting AWS services
Directory Service:
* Enables AWS resources to integrate with identity providers like Amazon Cognito and Microsoft AD domains

Simple Workflow (SWF):
* Coordinate a series of tasks involving a range of AWS services or even human events. It provides a programming model and infrastructure that make it easier for you to develop aynchronous and distributed applications.

API Gateway:
* Lets you create, publish, maintain, monitor and secure RESTful APIs and WebSocket APIs. Handles traffic management, authorisation, access control, throttling, monitoring and API version management
    * [Amazon API Gateway Overview](https://aws.amazon.com/api-gateway/)
    * [Amazon API Gateway Resources](https://aws.amazon.com/api-gateway/resources/)

## Tools for managing your AWS services

AWS Organizations:
* Create AWS accounts programmatically
* Centrally manage multiple AWS accounts programmatically
* Centrally audit, monitor and secure all your accounts. E.g., use oneaccount's GuardDuty or CloudTrail to alert on and monitor events across allyour accounts.
* Channel billing through a single payer
* Define security guardrails across all accounts

AWS Control Tower:
* Create AWS accounts programmatically (TODO: Compare with AWS Organizations)
* Automatically configure new accounts to comply with your security requirements. For example, configure AWS Firewall manager and automate service limit increases
* Prohibit creation and storage of data in certain regions

[AWS Service Catalog](https://aws.amazon.com/servicecatalog/features/):
* Restrict which IT services your users can use, where the IT services could be AWS services, AMIs, software, DBs and even entire multi-tier app architectures
* Restrict which options can be configured for those IT services
* Restrict which details can be viewed for those IT services
* Involves CloudFormation or Terraform

[AWS License Manager](https://aws.amazon.com/license-manager/features/):
* Centrally manage licenses from Microsoft, SAP, Oracle, IBM and other vendors across AWS and on-premises environments.
* Automatically assign licenses when launching EC2 instances and release licenses when destroying EC2 instances
* Notify administrators of license non-compliance by using Amazon SNS

AWS Artifact:
* Download compliance-related reports about AWS services, e.g., PCI DSS reports, ISO 27001 certifications
* Accept agreements for multiple accounts in your organisation

# Support plans

Described [here](https://aws.amazon.com/premiumsupport/plans/). They are:

* Basic: No tech support
* Developer: Only the root account can submit cases, and tech support is provided only during business hours
* Business: Root user and an unlimited number of IAM users can submit cases, with 24/7 phone, web and chat access
* Enterprise On-Ramp
* Enterprise


# Migrating workloads to AWS

[AWS Migration Hub](https://aws.amazon.com/migration-hub/features/):
* A single place to access all the tools and documentation that will help in migration to AWS.
* Import info about on-prem servers and applications
* Build a migration plan
* Get recommendations from AWS about migration strategy and app refactoring

[AWS Application Migration Service](https://aws.amazon.com/application-migration-service/resources/):
* Automate many parts of lifting-and-shifting bare-metal servers, VMs and cloud servers to AWS.

[AWS Database Migration Service](https://aws.amazon.com/dms/features/)
* Web service to migrate data from a DB that's on-prem, on an RDS DB instance or in a DB on an EC2 instance
* Minimises downtime because all changes to the source DB that occur during migration are continuously replicated to the target DB. 

[AWS Application Discovery Service](https://aws.amazon.com/application-discovery/features/):
* Discover on-prem servers and DBs, collecting details like hostnames, IP addresses, CPU/network/memory/disk usage and DB engine identity/version/edition.
* Identify dependencies between servers by recording inbound and outbound network activity.
* Measure on-prem server performance (CPU, mem, disk, network) so you can establish a performance baseline to use as a comparison after you migrate to AWS.

# AWS SLAs

Published [here](https://aws.amazon.com/legal/service-level-agreements/).

If AWS doesn't meet its SLA, it will give you some credit for a certain percentage of the direct costs that you incur whenever uptime falls below a defined threshold. For example, for EC2, the SLA agreement is [here](https://aws.amazon.com/compute/sla/?did=sla_card&trk=sla_card).


# Quiz
1. C :x: Should be B. To run your code on fully provisioned EC2 instances without having to manually configure and launch the necessary infrastructure, you should use AWS Elastic Beanstalk. It runs your code without you having to think about AWS compute and networking infrastructure. On the other hand, Amazon EC2 Auto Scaling requires you to have defined AMIs first.
2. A :heavy_check_mark:
3. D :heavy_check_mark:
4. C, E :x: Should be A, C. To integrate your company's local user access controls with some of your AWS resources, you can use IAM and AWS Directory Service. On the other hand, Amazon Cognito is an identity platform for web or mobile apps rather than Aws resources.
5. C :heavy_check_mark:
6. B :x: Should be D. The AWS Ireland region is ec2.eu-west-1.amazonaws.com, not eu-central-1.
7. A :heavy_check_mark:
8. B :heavy_check_mark:
9. C :heavy_check_mark:
10. B :heavy_check_mark:
11. A :heavy_check_mark:
12. A :heavy_check_mark:
