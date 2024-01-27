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

TODO ## Edge locations

TODO ## Benefits of edge locations, incl. AWS Global Accelerator

Suppose the master copy of your data is in Tokyo but many of your customers are in India. To improve performance for your Indian customers, you can cache a copy of the master data closer to the customer. This approach is called a CDN. Amazon's CDN is called CloudFront. CloudFront uses [Edge locations](https://aws.amazon.com/cloudfront/features/?whats-new-cloudfront.sort-by=item.additionalFields.postDateTime&whats-new-cloudfront.sort-order=desc) to store cached content.

## AWS Wavelength Zones

TODO ## AWS Wavelength Zones

## AWS Local Zones

TODO ## AWS Local Zones

## AWS Outposts

A service for running AWS infrastructure, services and tools in your own on-premises data centres in a hybrid approach. It's where AWS runs a mini-region inside your own building.

## AWS Local Zones

TODO: AWS Local Zones

## AWS Wavelength

TODO: AWS Wavelength

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