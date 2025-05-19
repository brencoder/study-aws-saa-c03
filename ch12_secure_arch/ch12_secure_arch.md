# Chapter 12 - Secure Architectures



## AWS Shared Responsibility Model

AWS is fully responsible for:
* Hardware, software, networking and facilities that run AWS Cloud services
* Physical security of its data centres

AWS and customer "share" responsibility for:
* Patch mgmt - AWS patches its infrastructure; customer patches its guest OSes and apps
* Config mgmt - AWS for its infrastructure; customer for its guest OSes, DBs, apps and its settings for AWS settings
* Training - AWS trains its employees; customer trains its own employees

Customer is totally responsible for their applications

## 1.1S4 Security strategy for multiple AWS accounts

### AWS Organizations
Advantages:
* Multi-account management
* Consolidated billing
* Centralised policies (SCPs, tagging policies)

In detail:
* Create AWS accounts programmatically
* Centrally manage multiple AWS accounts programmatically
* Centrally audit, monitor and secure all your accounts. E.g., use the management account's GuardDuty or CloudTrail to alert on and monitor events across all your accounts.
* Channel billing through a single payer
* Define security guardrails across all accounts



## Compliance

AWS complies with many standards, such as HIPAA, ISO 9001, ISO 27001, NIST and PCI.

AWS Artifact provides the compliance reports and lets you accept agreements for specific regulations

More helpful resources to help you pass third-party compliance checks of AWS are:
* [AWS Customer Compliance Center](https://aws.amazon.com/compliance/customer-center/)
* [AWS Compliance FAQ](https://aws.amazon.com/compliance/faq/)
* [AWS Risk and Compliance whitepaper](https://docs.aws.amazon.com/whitepapers/latest/aws-risk-and-compliance/welcome.html?did=wp_card&trk=wp_card)

## DDOS

Common DDOS attacks:
* UDP flood: You should configure security groups to block it
* Slowloris: You should direct customers to ELB, where ELB is massively scalable
* HTTP level attacks: You should use a combination of AWS WAF and AWS Shield, preferably AWS Shield Advanced, to block it

AWS Shield Standard is enabled by default at no additional charge. To get the most out of it, you should use Amazon CloudFront standard distributions, Amazon Route 53 hosted zones and AWS Global Accelerator standard accelerators.

AWS Shield Advanced is a paid service. It extends AWS Shield Standard and protects other AWS services, like ELB, resources associated with EIPs.

## AWS WAF

A web application firewall that monitors for suspicious web requests via HTTP and HTTPS to several AWS resources, mainly:
* CloudFront distribution
* API Gateway REST API
* ALB
* AppSync GraphQL API

If suspicious web requests are detected, AWS WAF can allow, block or count them

Types of suspicious web requests detected are:
* Suspicious source address
* SQLi
* XSS
* Custom patterns

## KMS

KMS consists of three types of keys:

* Customer managed key: Monthly fee for existence of keys (pro-rated hourly).
  Also charged for key usage.
* AWS managed keys: Deprecated in 2021. Replaced by AWS owned keys
* AWS owned keys: Not viewable by customer. No charges for customer. AWS
  manages rotation, deletion and Regional location

## Encryption

At-rest:
* Server-side encryption at rest is enabled on all DynamoDB table data, and integrates with KMS

In-transit:
* SSL/TLS. Possible with SQS, RDS, S3, RedShift and many more AWS services

## Amazon Inspector
Performs network assessments and host assessments so you can identify and remediate vulnerabilities

## Amazon GuardDuty
Identify threats through data from AWS CloudTrail, VPC flow logs, DNS logs, combined with integrated threat intelligence, including known malicious IP addresses, anomaly detection and machine learning.

You can configure AWS Lambda functions to run in response to security findings. See [this AWS blog page](https://aws.amazon.com/blogs/security/how-to-perform-automated-incident-response-multi-account-environment/) for an example.

## AWS Security Hub

Collects security data across AWS accounts, AWS services and even supported third-party products analyse your security trends, identify the highest priority security issues and even integrate with Amazon EventBridge to automatically remediate findings.

Uses input from GuardDuty, Inspector, Systems Manager, AWS Config, some other AWS services and even some AWS Partner Network services, e.g., Aqua Security.

Can display a dashboard of compliance with security standards:
![Dashboard of compliance with security standards](security_hub_security_standards.png)

Security standards consist of *security controls*, and AWS Security Hub can also show details of compliance with a particular security control.

AWS Security Hub produces *findings* about which resources of which accounts are not compliant with each security control, and provides links to remediation instructions. See below:
![A control in Security Hub](security_hub_control.png)

AWS Security Hub is cross-region.

It can even act on the findings through custom actions, like notifying CloudWatch Events, an EventBridge event bus (which in turn can have multiple targets), another AWS service or an EventBridge API destination (SaaS partner). The notified systems can in turn perform remediation.

## AWS Audit Manager

AWS Audit Manager continuously checks your AWS resources for compliance with prebuilt frameworks, like GDPR or HIPAA, or custom frameworks.

## Credential storage

AWS recommends different services for different types of credentials
* For DB credentials, API keys or OAuth tokens: AWS Secrets Manager
* For IAM credentials: AWS IAM
* For encryption keys: AWS KMS
* For SSH keys: Amazon EC2 Instance Connect
* For private keys and certs: AWS Certificate Manager

A deprecated way of storing credentials in AWS is by using AWS Systems Manager Parameter Store together with AWS KMS as per [this blog](https://aws.amazon.com/blogs/mt/the-right-way-to-store-secrets-using-parameter-store/).

## Security info from AWS

AWS Security Center doesn't exist anymore.

However, [AWS Security Documentation](https://docs.aws.amazon.com/security/) is a page with links to best practices, the Shared Responsibility Model, AWS Security Blog, security documentation per AWS service, and other AWS security resources (whitepapers, tutorials, training and so on).

[AWS Security Blog](https://aws.amazon.com/blogs/security/) is a list of security-related posts from [AWS Blog](https://aws.amazon.com/blogs)

## AWS Certificate Manager

Create, manage and renew SSL/TLS certs

## AWS CloudHSM

Generate crypto keys

## AWS Directory Service

It's a fully managed AD on AWS. Used to be called AWS Managed Microsoft AD (AWS MMAD)

## Amazon Detective

Help you to find the root cause of security findings or suspicious activities by creating *visualisations* based on ML, statistical analysis and graph theory.

## Amazon Macie

Help you identify and protect PI and SPI in S3 by using ML and pattern matching.

## AWS Resource Access Manager (AWS RAM)

Help you to share certain resources across AWS accounts or OUs. Shareable AWS resources include EC2 dedicated hosts, Route 53 resolver rules, Network Firewall policies and customer-owned IPv4 addresses.

Use cases:
* You spent a lot of money to buy something and you want to share that thing across your AWS accounts
* You configured something and don't want to repeat that configuration across your AWS accounts

## Amazon Cognito

A service that can authenticate user access to your web/mobile applications and AWS resources. The authentication can be delegated to a third-party IdP. Amazon Cognito can act as a layer of abstraction between IdPs and your application.

See [Common Amazon Cognito scenarios](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-scenarios.html)
