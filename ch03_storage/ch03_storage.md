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

S3 has different tiers of storage, called *storage classes*, with details [here](https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-class-intro.html). To choose the right storage class, consider two things:
* How available you need your data to be. That is, how well could you deal with the data being lost or corrupted?
* How frequently you need to access your data:
** Hot (frequently accessed)
** Warm (sometimes accessed)
** Cold (very infrequently accessed, e.g., once a year)

Key storage classes are:

| Storage Class | Description |
| --- | --- |
| S3 Standard |  Default storage class. It has 11 nines of durability. That is, 99.999999999% probability that a file in S3 Standard will remain intact after one year. To achieve this, data is stored in at least three Availability Zones. |
| S3 Standard-IA (Infrequent Access) | Suitable for data that must be kept for a long time, is not accessed frequently but needs to be available rapidly when required. Although you pay less for storing data in S3 Standard-IA, you must pay for reading the data. |
| S3 Intelligent-Tiering | If you're unsure of how frequently accessed your data will be, or the rate of access could change over time, then S3 Intelligent-Tiering could be the most appropriate option |
| S3 Glacier Flexible Retrieval | Suitable for audit data. Can create an *archive* within a *vault*. Can even *lock* your vault. Can specify a *vault lock policy*, such as write once/read many (WORM). Options for retrieval range from minutes to hours |
| S3 Glacier Deep Archive | Lowest cost storage but data retrieval could take between 12 to 48 hours. Data is stored in at least 3 AZs, so the data is highly available |

Other storage classes are:
| Storage Class | Description |
| --- | --- |
| S3 Express One Zone | Like S3 Standard, but stores your data in only one AZ. As a result, you can read the data up to 10x faster than you could with S3 Standard (hence *Express*) and you save around 50% compared with S3 Standard because you sacrifice the availability of your data |
| S3 One Zone-IA | Like S3 Standard-IA, where you pay to access your data, but you store your data in a single AZ only to get a discount |
| S3 Glacier Instant Retrieval | Like S3 Glacier Flexible Retrieval but more expensive because you are guaranteed millisecond access to your data |
| S3 Outposts | Stores objects in your on-premises AWS Outposts environment. Good if you have strict local data residency requirements or need extremely high performance |

If in doubt, choose S3 Standard or S3 Intelligent-Tiering as your storage class.

You can also use an *S3 lifecycle policy* to automatically move data between storage classes according to a schedule that you define. For example, you could keep data in S3 Standard at first, then move it to S3 Standard-IA after three months, and then S3 Glacier Flexible Retrival after one year.

Although an S3 bucket belongs to only one region, an S3 bucket's name must be globally unique across all regions.

## EFS

Advantages over EBS:
* Regional resource whereas an EBS volume is an AZ resource. So, instances can attach to an EFS file system in the same Region, regardless of AZ, whereas only instances in the same AZ can attach to an EBS volume.
* Multiple instances can read and write to it simultaneously as long as they are in the same Region, whereas an EBS volume can be attached to only only instance. The exception is that you can attach *io1* or *io2* EBS volumes to up to 16 Nitro-based instances.
* Automatically scales in size whereas resizing an EBS volume is a manual task.
* On-premises servers can access Amazon EFS using AWS Direct Connect.

## RDS

Without RDS, you could migrate your on-premises DB to AWS EC2, perhaps with the help of Amazon Database Migration Service.

On the other hand, with RDS, you get benefits such as AWS-managed patching, backups, redundancy, failover and disaster recovery.

An even more AWS-managed subtype of RDS is Amazon Aurora. It comes in two flavours - MySQL and PostgreSQL - and has 1/10th the cost of commercial databases. Benefits over normal RDS:
* High availability, with data replicated across facilities, with six copies at any time
* You can also deploy up to 15 read replicas to scale performance
* Continuous backup to Amazon S3
* Point-in-time recovery

## DynamoDB

Serverless database.

You create a table. The table consists of items. An item is a set of attributes, where an attribute is also called a key-value pair.

DynamoDB is usually a Region level service, across AZs.

However, you can also use the *DynamoDB global tables* feature to create a fully managed, serverless and multi-Region DB. It is also *multi-active*

Millisecond response time.

Not relational. Doesn't support SQL. No schema.

If data doesn't have a strict format and is being accessed extremely frequently, a NoSQL database is a better fit than a relational DB.

DynamoDB can handle over a trillion requests per day, or over 45 million requests per second.

Downside is that you can't query based on all attributes, but only based on certain key attributes. With NoSQL, your queries relate to one table, and do not do joins.

Which DB to choose - RDS or DynamoDB?
* If you must do complex joins, then use a relational database. For example, business analytics applications commonly need this.
* If you do not need to do complex joins but need massive scalability and fast reads and writes, then use a NoSQL database. For example, if you are just storing customer information and only have simple queries of the customer data, then a NoSQL database would be better.

## Redshift

Suitable for doing historical analytics over huge volumes of a huge variety of data. In other words, if you need a data warehouse for big data. Redshift is data warehousing as a service. It can run queries against exabytes of data.

## Database Migration Service

With DMS, the source DB remains fully operational during the migration.

Also, your source and destination DBs can be of different types.

If the source and destination DBs are of the same type, that is called a *homogenous* migration.

The source DB could be located:
* On-premises
* In EC2
* In RDS

The destination DB could be located:
* In EC2
* In RDS

On the other hand, for a *heterogeneous* migration, you must:
1. Convert the schema and code of the source DB to those of the dest DB
2. Migrate data from the converted source DB to the dest DB

Other use cases of DMS:
* Dev and test DB migrations. i.e., Create a copy of the prod DB for dev or testing purposes
* DB consolidation. i.e., Merging multiple DBs into one
* Continuous DB replication

You pay for DMS based on the capacity that you use on a per-hour basis.

## Additional database services

Niche DB use cases:
* Amazon DocumentDB: Content management system, like a catalogue or set of user profiles. Stores, queries and indexes JSON data natively. Based on MongoDB
* Amazon Neptune: A graph database, suitable for social networks, recommendation engines and fraud detection
* Amazon Managed Blockchain: Highly decentralised ledger system that lets multiple parties run transactions and share data without a central authority
* Amazon Quantum Ledger Database (QLDB): Provides 100% immutability for financial records or supply chain records

Database accelerators (caches):
* Amazon Elasticache: A caching layer on top of your DB to improve read times of common requests. Comes in two flavours, that is, memcached or redis
* Amazon DynamoDB Accelerator (DAX): A caching layer for DynamoDB. Improves response times from single-digit milliseconds to microseconds