# Chapter 9 - Data Ingestion, Transformation and Analytics

## Data analytics

Integrate your data lakes with data warehouses and data sources.

See the list of AWS analytics services [here](https://aws.amazon.com/big-data/datalakes-and-analytics/)

Can be split into three types:
* Advanced analytics:
    * [Amazon QuickSight](https://aws.amazon.com/quicksight/): A fast, cloud-powered business analytics service that you can use to build visualizations, perform analysis, and quickly get business insights from your data. It's like PowerBI.
    * Amazon CloudWatch: Monitor and manage various *metrics*, and configure alarm actions based on data from those metrics.
    * Amazon Athena: Query data in Amazon *S3* using ANSI *SQL*.
    * Amazon EMR: A fully managed service for running a *big data platform* like Apache Spark, Hive and Presto. See [Amazon EMR features](https://aws.amazon.com/emr/features/) and [Amazon EMR](https://aws.amazon.com/emr/).
    * Amazon Redshift: *Data warehouse*. That is, a system for getting fast responses to complex queries about data from from multiple sources, like transactional systems and relational databases. Stores data in a structured format.
    * Amazon Managed Service for Apache Flink: Query and analyse streaming data or real-time data. E.g., to process IoT data or to feed real-time dashboards. Used to be called Kinesis Data Analytics
    * Amazon OpenSearch Service: Search and analyse huge volumes of real-time data from, say, real-time application monitoring, SIEM, log analytics and searching within your apps/websites/data lake catalogs. It's a fully managed version of the open source OpenSearch product, where OpenSearch was forked from Elasticsearch. Difference between Flink is that Flink operates on data streams whereas OpenSearch can operate on conventional data sources.
* Data management:
    * AWS Glue: *ETL* for big batches of data.
    * Amazon Kinesis Data Firehose: *ETL* for data streams, outputting to data lakes, data stores and analytics services.
    * Amazon Managed Streaming for Apache Kafka (MSK): Can act as publisher/subscriber notification system, a metrics aggregator, a log aggregator or ETL system.
    * Amazon Kinesis Data Streams: Capture, process and send real-time data streams like transaction logs, app logs, website clickstreams and IoT telemetry data to a variety of processing systems, like Amazon Kinesis Data Analytics, Amazon EC2 or AWS Lambda.
    * Amazon Kinesis Video Streams: Stream video from camera devices to AI/ML tools, analytic tools and other video processors.
    * AWS Lake Formation: Manage access to a data lake's data in S3 and also a data lake's metadata (Data Catalog). Amazon doesn't have a *data lake* solution as such, but you can build one using a collection of components from AWS. See [AWS: What is a Data Lake?](https://aws.amazon.com/what-is/data-lake/)
    * AWS Data Exchange: It's a marketplace for data sets. Find and access to third-party data sets, or share your data sets with others.
* Predictive analytics and ML:
    * Amazon SageMaker: Build, train and deploy ML models
    * Amazon Redshift ML: Provides a SQL interface to create and train ML models in Amazon SageMaker. Saves you from having to learn Amazon SageMaker's tools and languages, and saves you from having to know much about ML.



Amazon Kinesis: Process and analyse streams of real-time data, like application logs, IoT telemetry data, video and audio to targets. Consists of three products:
* Amazon Kinesis Data Analytics: