# Chapter 1 - Intro to AWS

## Benefits of AWS

Six main benefits:
* Trade fixed expense for variable expense. So, you can start small rather than making huge upfront hardware purchases
* Benefit from massive economies of scale. So, you pay less due to AWS' bargaining power with hardware manufacturers, software developers, datacentre operators and so on
* Stop guessing capacity. Start small and add or remove capacity quickly or even automatically. This saves you money
* Increase speed and agility. Spin up test environments or applications for experimental new business ventures quickly, and delete the test environments or applications easily
* Stop running datacentres yourself
* Go global in minutes. E.g., to expand an Aussie business to Germany, you don't need to recruit a team in Germany. You just make a few API calls

## Well-Architected Framework

![The six pillars of the Well-Architected Framework](well_architected_framework_pillars.png)

Well-Architected Framework consists of six pillars (OESRPECOS):
* Operational excellence: Running and monitoring to deliver business values, and continually improving the supporting processes and procedures, e.g., through IaC, frequent small changes, automation and automated monitoring
* Security
* Reliability: Make sure your business applications keep running or at least recover quickly if some of the components that they run on fail; and scaling up to meet unexpected or large demands
* Performance efficiency: Reduce unused compute, storage and network capacity; quickly change the capacity to meet business demand and to keep up with technological changes
* Cost optimisation
* Sustainability: Minimising energy consumption

AWS provides the AWS Well-Architected Tool to assess your AWS account against the six pillars and provide recommendations.

There is *no charge* for the AWS Well-Architected Tool.

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


## Migrating workloads to AWS

### AWS Cloud Adoption Framework

Has advice that is organised into six areas, called *Perspectives* (BPGPSO):
* Business: Ensures that IT aligns with business needs, i.e., there is a strong business case for migrating to the cloud
* People: Implements organisation-wide change management to ensure successful cloud migration and maintenance. Could involve hiring or retraining staff, and potentially also restructuring your organisation
* Governance: Ensures that you maximise business value and minimise risks
* Platform: Fit AWS into your organisation's IT architecture
* Security: Implements security controls
* Operations

Where the Business, People and Governance pPerspectives focus on business capabilities, while the Platform, Security and Operations Perspectivies focus on technical capabilities. By considering each Perspective in turn, you identify gaps in your skills and processes. These gaps are called *inputs*. From the inputs, you create an AWS Clouad Adoption Framework *action plan*.

### Six R's of migration

* Rehost: Lift and shift
* Replatform: Link, tinker and shift. i.e., make some cloud optimisations but don't change any core code. E.g., migrate on-prem MySQL to RDS
* Retire
* Retain: Keep on-prem
* Repurchase: Go from on-prem to SaaS, e.g., something from AWS Marketplace. e.g., Go from on-prem CRM to Salesforce.com
* Refactor/re-architect: Write new code that uses cloud-native features. Dramatic change to your architecture.

### Migration services

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

## AWS SLAs

Published [here](https://aws.amazon.com/legal/service-level-agreements/).

If AWS doesn't meet its SLA, it will give you some credit for a certain percentage of the direct costs that you incur whenever uptime falls below a defined threshold. For example, for EC2, the SLA agreement is [here](https://aws.amazon.com/compute/sla/?did=sla_card&trk=sla_card).

## AWS support plans

Basic support is offered to all customers. It includes support for account and billing questions and service quota increases; pay-by-the-month technical support cases; forums; AWS Trusted Advisor's basic checks; and AWS Personal Health Dashboard

Premium support plans are:
* Developer support: Basic support, plus unlimited technical support cases; direct email access to customer support with 24 hour response time or 12 hours if your system is impaired; and building-block architecture support to advise you on combining AWS services together
* Business support: Developer support, plus AWS Trusted Advisor's full set of checks; direct phone access to cloud support engineers with 4 hour response time if your production system is impaired and 1 hour response time if your production system is down; and infrastructure event management, where AWS offers a paid service to advise on architecture and scaling for a business event, e.g., product launch
* Enterprise On-Ramp Support: Developer support, plus 30 minute response time for business critical workloads; and rate-limited access to a pool of TAMs
* Enterprise: Developer, plus 15 minute response time for business critical workloads; a dedicated TAM

More details are at:
* [AWS Support Plans](https://docs.aws.amazon.com/awssupport/latest/user/aws-support-plans.html)
* [Compare AWS Support Plans](https://aws.amazon.com/premiumsupport/plans/)

TAM performs infrastructure event management, Well-Architected Framework reviews, operations reviews

## Innovation with AWS

Machine learning and AI:
* Amazon SageMaker: Build, train and deploy ML models
* Amazon Augmented AI (Amazon A2I): An ML platform
* Amazon Lex: Ready-to-go chatbot
* Amazon Textract: Extract text from scanned documents
* Amazon Transcribe: Speech to text
* Amazon Comprehend: Discover patterns in text
* AWS DeepRacer: Let developers try reinforcement learning using 1/18 scale race car

Satellites: AWS Ground Stations, which is pay-as-you-go access to a satellite

## Quiz
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
