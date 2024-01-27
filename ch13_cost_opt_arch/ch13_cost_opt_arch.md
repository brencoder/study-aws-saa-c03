# Chapter 13 - Cost-Optimised Architectures

## AWS Free Tier

Consists of three types of offers:
* Always free: E.g., 1 million free invocations of AWS Lambda functions per month; 25 GB of free storage on Amazon DynamoDB per month
* Free for 12 months: E.g., some S3 Standard Storage; some EC2 compute time; some CloudFront outbound data transfer
* Trials: E.g., 90 days of Amazon Inspector

## AWS pricing concepts

* Pay for what you use
* Pay less when you reserve, e.g., with Savings Plans
* Pay less per unit when you use more

Examples:
* AWS Lambda charges you based on the number of requests made to your functions and how long the functions ran for.
* AWS ELB charges you based on how long your ELB has been used, how many connections it processed and how much data it transferred
* AWS S3 charges you based on how much data you store; what tier you store it at; how many requests you made to add, copy or retrieve your S3 objects; how much data you transferred into or out of S3; and what management features you enabled, e.g., object tagging

## Data transfer charges
TODO ## Data transfer charges

## Billing dashboard

## Consolidated billing

Done through AWS Organizations. Apart from centrally viewing and paying bills, consolidated billing also lets you save money by:
* Sharing AWS Savings Plans across your accounts
* Qualifying for volume-based discounts based on aggreated usage across your accounts

## AWS Budgets

TODO ## AWS Budgets

Receive email alerts when your costs exceed or are forecast to exceed your budgeted amounts or, say, 80% of your budgeted amounts.

The information in AWS Budgets is updated three times a day, not in real-time.

## AWS Pricing Calculator

TODO ## AWS Pricing Calculator. What are its use cases and capabilities?

## Cost allocation tags

TODO ## Cost allocation tags

TODO Relationship between cost allocation tags and billing reports (e.g., AWS Cost and Usage Report)

## AWS Billing Conductor

TODO ## AWS Billing Conductor

## AWS Cost Explorer

Breaks down your costs by AWS service. Can further break it down by region, account and tag. Shows you the past 12 months of cost data.

Lets you create custom reports.

AWS Cost Explorer charges you based on the number of requests you make to it; and whether you want hourly granularity for the past 14 days of usage.


## AWS Marketplace

It's a place for you to find, test, buy and deploy third-party software to AWS. In some cases, you can even do one-click deployment. Usually they are pay-as-you-go offerings. Enterprises can even negotiate custom terms and pricing.

A private marketplace is even available.

AWS Marketplace can even integrate into your organisation's procurement systems through the Commerce XML (cXML) protocol.

TODO Key services of AWS Marketplace, incl. cost mgt, governance and entitlement

## AWS Trusted Advisor

TODO ## AWS Trusted Advisor

Evaluates your AWS account against five pillars: (COPSFTSL)
* Cost optimisation: E.g., buy AWS savings plans; turn off or vertically downscale EC2 instances; and vertically downscale EBS volumes
* Performance: E.g., High-throughput EBS volumes are attached to low-throughput EC2 instances
* Security: E.g., S3 buckets have open permissions; MFA not enabled for root user; security groups are too permissive; IAM access keys should be rotated
* Fault tolerance: E.g., EBS volumes without snapshots (backups), so you are at risk of data loss; EC2 instances are not balanced across AZs, RDS DB instances are launched in only one AZ
* Service limits: E.g., You have reached the limit of five VPCs per region

Some checks are free; others are only available if you have premium support plans.

AWS Trusted Advisor can send emails to your account's alternate contacts for billing, operations and security.

## AWS Health Dashboard
TODO ## AWS Health Dashboard

## AWS Health API
TODO ## AWS Health API

