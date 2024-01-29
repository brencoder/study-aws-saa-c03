# Storage

## Instance stores and Amazon EBS

The instance stores of an EC2 instance are ephemeral, that is, the instance stores get cleared when you stop the EC2 instance. This is because the instance stores are attached directly to a physical host in AWS but, when you stop and start an EC2 instance, AWS could very well start the EC2 instance on another physical host, where the instance stores do not exist.

For persistent storage of an EC2 instance's files, you can create a *volume* in Amazon EBS.

An EBS volume can be up to 16 TiB in size.

To back up an EBS volume, you create an *EBS snapshot*. An EBS snapshot is an incremental backup of a volume.

[An EBS snapshot is incremental](ebs_snapshot_is_incremental.png "An EBS snapshot is incremental")

An EBS volume is solid state (SSD) by default but you could create it as a magnetic drive (HDD) instead.

## S3

S3 is object storage. An object has data, metadata and a key. A rough analogy for an object is a file.

An object is stored in a *bucket*.

When you modify a file in block storage, only the pieces that are changed are updated. When a file in object storage is modified, the entire object is updated. In other words, S3 is write once/read many (WORM).

Maximum file size is 5 TB, although the Amazon S3 console allows a maximum file size of only 160 GB. To upload files that are greater than 160 GB but less than or equal to 5 TB, use the AWS CLI, AWS SDKs or Amazon S3 REST API.

S3 has different tiers of storage, called *storage classes*, with details [here](https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-class-intro.html). To choose the right storage class, consider:
* Resiliency: How well you could deal with the data being lost or corrupted?
* Retrieval time: How quickly do you want AWS to send the object to you upon request?
* How frequently you need to access your data
* Cost for storage and retrieval

Storage classes are:

| Storage Class | Description |
| --- | --- |
| S3 Standard |  Default storage class. It has 11 nines of durability. That is, 99.999999999% probability that a file in S3 Standard will remain intact after one year. To achieve this, data is stored in at least three Availability Zones. |
| S3 Express One Zone | Fastest retrieval time. It's based on S3 Standard, but stores your data in only one AZ. As a result, you can read the data up to 10x faster than you could with S3 Standard (hence *Express*) and you save around 50% compared with S3 Standard because you sacrifice the availability of your data |
| S3 Standard-IA (Infrequent Access) | Suitable for data that must be kept for a long time, is not accessed frequently but needs to be available rapidly when required. Although you pay less for storing data in S3 Standard-IA, you must pay for reading the data. |
| S3 One Zone-IA | Like S3 Standard-IA, where you pay to access your data, but you store your data in a single AZ only to get a discount |
| S3 Intelligent-Tiering | If you're unsure of how frequently accessed your data will be, or the rate of access could change over time, then S3 Intelligent-Tiering could be the most appropriate option. How itIt moves objects from S3 Standard after a default of 30 days of inactivity to S3 Standard-IA, and moves objects back to Standard when they are accessed again. If you enable the Archive Access tier, then if the item hasn't been accessed for a default of 90 days, it is moved to the S3 Glacier storage class. |
| S3 Glacier Flexible Retrieval (formerly S3 Glacier) | Suitable for audit data, or other data that is rarely accessed and does not require immediate access. Can create an *archive* within a *vault*. Can even *lock* your vault. Can specify a *vault lock policy*, such as write once/read many (WORM). Options for retrieval range from minutes to hours |
| S3 Glacier Instant Retrieval | Like S3 Glacier Flexible Retrieval but more expensive because you are guaranteed millisecond access to your data |
| S3 Glacier Deep Archive | Lowest cost storage but data retrieval could take between 12 to 48 hours. Data is stored in at least 3 AZs, so the data is highly available |
| S3 Outposts | Stores objects in your on-premises AWS Outposts environment. Good if you have strict local data residency requirements or need extremely high performance |


If in doubt, choose S3 Standard or S3 Intelligent-Tiering as your storage class.

Although an S3 bucket belongs to only one region, an S3 bucket's name must be globally unique across all regions.

You can also use an *S3 Lifecycle policy* to automatically move a bucket between storage classes according to a schedule that you define. For example, you could keep data in S3 Standard at first, then move it to S3 Standard-IA after three months, and then S3 Glacier Flexible Retrival after one year.

## Other types of lifecycle policy, apart from S3

* Bucket lifecycle policy
* EBS snapshot lifecycle policies, manged through [Amazon Data Lifecycle Manager](https://docs.aws.amazon.com/* AWSEC2/latest/UserGuide/snapshot-lifecycle.html)
* ECR lifecycle policy

## EFS

Advantages over EBS:
* Regional resource whereas an EBS volume is an AZ resource. So, instances can attach to an EFS file system in the same Region, regardless of AZ, whereas only instances in the same AZ can attach to an EBS volume.
* Multiple instances can read and write to it simultaneously as long as they are in the same Region, whereas an EBS volume can be attached to only only instance. The exception is that you can attach *io1* or *io2* EBS volumes to up to 16 Nitro-based instances.
* Automatically scales in size whereas resizing an EBS volume is a manual task.
* On-premises servers can access Amazon EFS using AWS Direct Connect.

## Amazon FSx

A fully-managed, high-performance, third-party file system like NetApp ONTAP or Windows File Server.

## AWS Storage Gateway

Connect on-prem software appliances with AWS storage.

Four types:
* Amazon S3 File Gateway, for connecting your on-prem app to S3 via NFS or SMB
* Amazon FSx File Gateway, for connecting your on-prem app to Amazon FSx for Windows File Server via SMB
* Tape Gateway, for storing archive backup data in S3 Glacier Flexible Retrieval or S3 Glacier Deep Archive
* Volume Gateway, for your on-prem app to mount an S3 bucket as an iSCSI volume

## AWS Backup

Back up EC2 instances, S3 data, EBS volumes, DynamoDB tables, CloudFormation stacks and many other AWS resources.

Features:
* Cross-region
* Cross-account
* Incrememental backups
* Restore testing

## AWS Snow Family

It's for quickly moving huge amounts of data from on-premises environments to AWS. This is better done physically rather than over the network.

* AWS Snowcone is a small, rugged edge computing and data transfer device that holds up to 14 TB. You copy the data to the physical device and send it back to AWS.
* AWS Snowball Edge holds up to 80 TB. It plugs into your server rack. It's good for improving processing speed in disconnected, austere edge environments with little or no connectivity. Example use cases are capturing of streams from IoT devices, image compression or industrial signalling. Comes in two types: Storage Optimised and Compute Optimised.
* AWS Snowmobile. It is used for transferring up to 100 PB of data. 45-ft shipping container, pulled by a truck. It plugs in to your datacentre and appears as a NAS to your servers. Has fire suppression, GPS tracking, 24/7 video surveillance and a security escort.

## AWS Transfer Family

Enables you to use SFTP, FTPS or FTP to transfer files in to or out of Amazon S3 and Amazon EFS.

## AWS Elastic Disaster Recovery (AWS DRS)

Recover your on-prem or cloud-based applications to AWS.

Continuously performs data replication and monitors the data replication too.

Can perform on-demand and periodic testing of disaster recovery to a staging area.

You can launch recovery instances on AWS in minutes using the latest server state or a previous point in time.

After recovery, you can keep your applications on AWS or replicate your data back to your primary site.

You can fail back to your primary site when you're ready.

Use cases:
* Disaster recovery of on-prem applications to AWS
* Disaster recovery of Azure applications to AWS
* Disaster recovery from one AWS region to another