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

### SQS:
* Uses "queues" in a producer-consumer model.
* There is a party at each end of the queue.
* A queue has a single direction, so there is a producer and consumer.
* The producer puts messages on the queue and the consumer reads messages from the queue.
* No messages are lost. SQS guarantees this.
* Billed by number of API requests.
* Two types of queues: Standard and FIFO

#### Standard queues

* Best-effort ordering: Messages are usually, but not always, delivered in the order they were sent.
* At-least-once-delivery: A message is guaranteed to be delivered but could be delivered multiple times.
* Unlimited throughput: A nearly unlimited number of API calls per second.

#### FIFO queues

* Guaranteed order of delivery
* Exactly-once delivery
* Limited throughput: FIFO queues process up to:
   * 3000 messages per second *per API method* if you use batching (that is, if you call `SendMessageBatch`, `ReceiveMessageBatch` or `DeleteMessageBatch`). In particular, up to 300 API calls per second, with each API call handling a batch of 10 messages.
   * 300 messages per second if you do not use batching.
   * 70000 messages per second without batching and even higher with batching if you use *high throughput mode*

#### Choosing between standard and FIFO queues

Choose FIFO queues if order is essential and lack of duplicate messages is essential.

#### Dead-letter queues

When you create a dead-letter queue, you specify the *maximum receives* value, which is the number of times a message can be received before being sent to the dead-letter queue

Note: The maximum receives value is set during creation of a dead-letter queue, not during creation of a source queue.

If a message stays in a dead-letter queue for too long, the *dead-letter queue redrive* feature moves the unconsumed message to a *redrive destination*, for example, the source queue. Note that the dead-letter queue and redrive destination must be of the same type. For example, if the dead-letter queue is standard queue, the redrive destination must be a standard queue, too.

#### Delay queues

A setting of a queue. It specifies how long a message remains hidden from consumers after the message is *first added* to the queue. Maximum value is 15 minutes. Defaults to 0 seconds.

A delay queue is not a type of queue. It is the *delivery delay* option of the queue creation API.

If you want to configure the enqueue hiding period *per-message*, then you set a *message timer* or *delivery delay* when sending a message.

#### Visibility timeout

A setting of a queue or message. It specifies how long a message remains hidden from consumers after the message is received via `ReceiveMessage` or `ReceiveMessageBatch`. Maximum value is 12 hours. Defaults to 30 seconds.

If you need a longer limit, consider using AWS Step Functions or breaking the task into smaller steps.

The consumer should call the `DeleteMessage` API before the visibility timeout expires. Otherwise, the message re-appears on the queue. Certain AWS SDKs automatically call `DeleteMessage` for you after successful processing of a message. 

You configure the per-queue visibility timeout when creating a queue.

You configure the per-message visibility timeout by calling the `ChangeMessageVisibility` action. 

#### Comparing delay queues and visibility timeouts

Both delay queues and visibility timeouts temporarily hide a message. The difference is *when* the hiding starts. With delay queues, the hiding starts when the message is first added to a queue. With visibility timeouts, the hiding starts when the message is received.


### SNS:
* Uses "topics" in a publish-subscribe model.
* You send or publish a message to a topic, and the message will "fan-out" to all subscribers or endpoints in a single go. It's like multi-cast.
* Subscribers could be SQS queues, Lambda functions, HTTPS web hooks or even users' mobile push (app notification), SMS and email.

## Amazon EventBridge

Routes events between your application components.

Events can be produced by your apps, microservices, SaaS apps and AWS services.

Events can be consumed by multiple targets via *event buses* or single targets via *pipes*.

Targets can be AWS Lambda functions, Amazon SNS topics, other AWS service targets, or an API
