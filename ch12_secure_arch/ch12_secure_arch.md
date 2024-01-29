# Chapter 12 - Secure Architectures

## AWS Shared Responsibility Model

TODO: Define who is responsible for what

TODO: LIst shared responsibilities

## AWS Organizations
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

TODO ## AWS WAF

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

TODO: Try Security Hub out

Collects security data across AWS accounts, AWS services and even supported third-party products analyse your security trends, identify the highest priority security issues and even integrate with Amazon EventBridge to automatically remediate findings.

## AWS Audit Manager

TODO AWS Audit Manager

## AWS Config

TODO AWS Config

## Credential storage

TODO AWS Secrets Manager
TODO AWS Systems Manager for credential storage

## Security info from AWS

TODO: AWS knowlege center
TODO: AWS Security Center
TODO: AWS Security Blog

## TODO AWS Certificate Manager

## TODO AWS CloudHSM

## TODO AWS Directory Service

## TODO Amazon Detective

## TODO Amazon Macie

## TODO AWS Resource Access Manager (AWS RAM)