# Chapter 10 - Resilient Architectures

## AWS Regions

To implement with data sovereignty, a design law of AWS is that no data goes in or out of a region unless you explicitly request it.

Which region to choose?
* Do compliance or regulatory requirements dictate it?
* Proximity to customers
* Feature availability
* Pricing

Each Region consists of at least three Availability Zones. They are placed around 10s of miles apart, up to a maximum of 60 miles (100 km), that is, as far away from each other as possible while keeping latency low.

For example, the ap-southeast-2 Region consists of three AZs: ap-southeast-2[a|b|c]

## AWS Availability Zones

One or more discrete data centres with redundant power, network and connectivity.

Each AZ belongs to only one Region.

All traffic between AZs is encrypted.

Many services run at a Regional level, e.g., ELB

However, an EC2 instance runs an AZ level

## Edge locations

To provide high performance for some AWS services, AWS runs extra data centres in addition to those in AZs. Those extra data centres are called *edge locations*. CloudFront and Route 53 use edge locations.

To understand why CloudFront uses edge locations, imaging that the master copy of your data is in Tokyo but many of your customers are in India. To improve performance for your Indian customers, you can cache a copy of the master data closer to the customer. This approach is called a CDN. Amazon's CDN is called CloudFront. CloudFront uses [Edge locations](https://aws.amazon.com/cloudfront/features/?whats-new-cloudfront.sort-by=item.additionalFields.postDateTime&whats-new-cloudfront.sort-order=desc) to store cached content.

## AWS Local Zones

Where AWS provides a subset of its services in extra AWS-run data centres, outside of AZs, so that users have lower latency to your applications or so that you meet data sovereignty requirements (e.g., where a state government's data must remain in the same state). You can access the other services of the same Region.

Note that edge locations are for making AWS' own services faster whereas Local Zones are for making your applications faster.

## AWS Global Accelerator

A network layer load-balancing service that directs traffic to optimal endpoints across Regions. Endpoints could be NLBs, ALBs or EC2 instances. Users access AWS Global Accelerator through a pair of *static* IP addresses. The routing of requests does not rely on changes in DNS records, in contrast to dynamic DNS load balancing solutions like Amazon Route 53 Traffic Flow.

## AWS Wavelength Zones

Where a communications service provider runs AWS compute and storage services in their 5G networks to enable applications that require ultra-low latency connections to consumers and also connectivity to AWS services. Use cases include connected vehicles or video platforms.

## AWS Outposts

A service for running AWS infrastructure, services and tools in your own on-premises data centres in a hybrid approach. It's where AWS runs a mini-region inside your own building.

## Messaging and queueing

Tightly coupled - synchronous. Monolithic. If a single component fails, other components or even the entire application also fail.

Loosely coupled - asynchronous. Distributed. If a single component fails, the other components continue to work because they communication with each other via a third-party.

SQS:
* Uses "queues" in a producer-consumer model.
* There is a party at each end of the queue.
* A queue has a single direction, so there is a producer and consumer.
* The producer puts messages on the queue and the consumer reads messages from the queue.
* No messages are lost. SQS guarantees this.

SNS:
* Uses "topics" in a publish-subscribe model.
* You send or publish a message to a topic, and the message will "fan-out" to all subscribers or endpoints in a single go. It's like multi-cast.
* Subscribers could be SQS queues, Lambda functions, HTTPS web hooks or even users' mobile push (app notification), SMS and email.

## Amazon EventBridge

Routes events between your application components.

Events can be produced by your apps, microservices, SaaS apps and AWS services.

Events can be consumed by multiple targets via *event buses* or single targets via *pipes*.

Targets can be AWS Lambda functions, Amazon SNS topics, other AWS service targets, or an API