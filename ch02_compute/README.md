# Chapter 2 - Compute Services

Refer to [Amazon EC2 Documentation](https://docs.aws.amazon.com/ec2/index.html).

## EC2 instances

### Instance types

Summary of [Amazon EC2 instance types](https://aws.amazon.com/ec2/instance-types/):

|Family|Types|Suited for|
|---|---|---|
|General|T, M (Multi-purpose), A1, Mac|Web servers, code repos|
|Compute optimised|C (Compute)|Batch processing, media transcoding, machine learning, high performance web servers|
|Memory optimised|R (RAM), X, High Memory, z1d|Very large datasets in memory. Databases, data analysis and caching|
|Accelerated computing|P (Performance), G (Graphics), Trn1 (deep learning Training), Inf (deep learning Inference), F1 (FPGA), VT1 (Video Transcoding)|AI, high-end financial workloads, medical research|
|Storage optimised|Im, Is, I, D (Data), H|Very large datasets in local storage. Distributed filesystems, heavyweight data processing|
|HPC optimised|Hpc|Weather forecasting, computational fluid dynamics, molecular dynamics|

See [instance type naming convention](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-types.html#instance-type-names) to understand what `c7gn.xlarge` means.

### Tenancy model

__Shared tenancy__: Your instance runs on a physical server that could also be running the instances of other AWS customers.

[Dedicated Instance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/dedicated-instance.html):
* Your instance runs on a physical server that is dedicated to your organisation, where you have no visibility of the physical server's details and no control over how instances are placed onto the physical server.
* You have no visibility of the number of sockets and physical cores of the physical server. Hence, it is hard to use licenses that are based on the number of sockets or physical cores.

[Dedicated Host](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/dedicated-hosts-overview.html):
* Your instance runs on a physical server that is dedicated to your organisation, where you can find out the ID and number of vCPUs of the physical server; control how instances are placed on it through [auto-placement and host affinity](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/how-dedicated-hosts-work.html#dedicated-hosts-understanding); and track configuration changes to it.
* The main purpose of Dedicated Host is to use your existing per-core, per-socket or per-VM licenses.
* You allocate physical servers (Dedicated Hosts) to your account via the [allocate-hosts](https://docs.aws.amazon.com/cli/latest/reference/ec2/allocate-hosts.html) CLI command. The response is a list of host IDs, where a host ID could look like "h-07987acf34EXAMPLE"
* AWS could move your instance to a different physical server during [host maintenance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/dedicated-hosts-maintenance.html) or [Dedicated Host auto recovery](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/dedicated-hosts-recovery.html)
* If you choose to use "Dedicated Host shring", you can create and manage Dedicated Hosts centrally and share them across multiple AWS accounts or within your AWS organisation.

### [User data](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html)

* It is base64-encoded text.
* It is base64-decoded automatically if you retrieve it using instance metadata or the console.
* The maximum size of the text is 16 KB.
* You can retrieve user data from the following URI of the Instance Metadata Service (IMDS): [http://169.254.169.254/latest/user-data](http://169.254.169.254/latest/user-data).
* You can choose to have the user data run one time at launch, or every time you reboot or start the instance.
* If the root volume is an EBS volume, then you can modify the instance data for an instance in the stopped state.
* To cater for multiple operating system types, user data can be any text. However, for Linux instances, the user data must be one of these types:
    * A shell script
    * [cloud-init](https://cloudinit.readthedocs.io/en/latest/index.html) directives
    * A mime-multi part file including both a shell script and cloud-init directives
* If the user data is just a shell script:
    * It must start with `#!`.
    * It runs as root, so don't use sudo.
    * It is not run interactively, so you can't include commands that prompt for user input (such as `yum update` without the `-y` option).
    * If it calls the AWS API or AWS CLI, an instance profile must be used so the script gets the appropriate AWS credentials.
* If the user data is just a series of cloud-init directives:
    * It must start with `#cloud-config` and be followed by YAML.
    * Example:

        ```
        #cloud-config
        repo_update: true
        repo_upgrade: all

        packages:
         - httpd
         - mariadb-server

        runcmd:
         - [ sh, -c, "amazon-linux-extras install        -y lamp-mariadb10.2-php7.2 php7.2" ]
         - systemctl start httpd
         - sudo systemctl enable httpd
         - [ sh, -c, "usermod -a -G apache        ec2-user" ]
         - [ sh, -c, "chown -R ec2-user:apache         var/www" ]
         - chmod 2775 /var/www
         - [ find, /var/www, -type, d, -exec,        chmod, 2775, {}, \; ]
         - [ find, /var/www, -type, f, -exec,        chmod, 0664, {}, \; ]
         - [ sh, -c, 'echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php' ]
         ```

* Whatever the type of the user data, the logs of the user data are at: `/var/log/cloud-init-output.log`.

### [Placement groups](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html)

By default, AWS places EC2 instances on physical servers so that the impact of correlated failures is minimised. A correlated failure is where multiple independent components fail due to a common reason.

If you have *interdependent* instances, then you can use *placement groups* to influence the placement of instances across physical servers.

You can create a placement group using one of three placement strategies: cluster, partition and spread.

#### Cluster
* What is it?
    * Puts instances close together inside an AZ.
    * Can span multiple peered VPCs in the same region.
* Why use it?
    * Good for workloads requiring low network latency, high network throughput or both.
    * Suitable workloads include high-performance computing (HPC) applications.
* Tips for avoiding "insufficient capacity error":
    * Use a single request to launch all instances of a cluster placement group.
    * Use a common instance type for all instances in a cluster placement group.

#### Partition

* What is it?
    * Spreads instances across logical partitions. You number the partitions 1, 2, 3, and so on, up to a maximum of 7.
    * Amazon EC2 ensures that each partition has its own set of racks. So, the impact of a single hardware failure affects just one partition.
* Why use it?
    * Good for reducing the likelihood of correlated hardware failures for your application.
    * Suitable workloads involve large distributed and replicated processing. For example, Hadoop, where a network of many computers solves a problem involving massive amounts of data and computation.

#### Spread

* What is it?
    * A group of instances where each instance is placed on distinct hardware.
* Why use it?
    * Good for applications that have a few important instances that must be kept separate from each other.
    * Reduce the risk of correlated failures when instances share the same equipment.
* Two types of spread placement groups:
    * Rack spread level placement groups - e.g., where seven instances in a common AZ are placed on seven different racks, where each rack has its own network and power source.
    * Host level spread level placement groups - only available with [AWS Outposts](https://docs.aws.amazon.com/outposts/latest/userguide/what-is-outposts.html), where AWS Outposts is a fully managed service where AWS operates that part of your on-premises datacentre as part of an AWS region

Difference between partition and spread:
* With spread placement groups, no two *instances* of a spread placement group will ever be on the same hardware.
* With partition placement groups, no two *partitions* will ever be on the same hardware. However, within a given partition, two instances could be on the same hardware.

### Instance pricing

Models: on-demand, reserved, spot, AWS Savings Plan and scheduled.

#### On-demand
Pay per hour or per second, with a minimum spend of 60 seconds and no term commitment.

#### Reserved

If you plan to run an instance for over a year, you should consider buying a Reserved Instance to save money.

A Reserved Instance is not a type of instance but rather a billing discount on On-Demand Instances that match a certain *configuration* in return for committing to payment for a certain *term*, or amount of time.

A configuration consists of:
* Instance type: E.g., `t2.micro` or `c7gn.xlarge`
* Scope: either a particular region or a particular Availability Zone
* Tenancy: shared (default), Dedicated Instance or Dedicated Host
* [Platform](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ri-market-concepts-buying.html#ri-choosing-platform): which OS. Options include:
    * Linux/UNIX (excluding SUSE Linux and RHEL)
    * Linux with SQL Server (with subcategories for SQL Server Standard, Web and Enterprise)
    * SUSE Linux
    * RHEL
    * RHEL with HA
    * Windows
    * Windows with SQL Server (with subcategories for SQL Server Standard, Web and Enterprise)

    > **NOTE:** When buying a Reserved Instance, make sure that its `PlatformDetails` field matches that of of the On-Demand Instances that you want to apply the Reserved Instance on.

To buy a Reserved Instance, you must commit to a term of either:
* One year
* Three years

When the term of a Reserved Instance expires, you continue using its EC2 instance at on-demand rates until you terminate the instances or purchase new Reserved Instances that match the instance attributes.

The discount offered by a Reserved Instance depends on not just the term but also your payment option:
* All upfront
* Partial upfront
* No upfront

If your compute needs change, you might want to change your Reserved Instance or sell it. At purchase time, you should assess what types of changes you are likely to need, and then decide which [offering class](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/reserved-instances-types.html) to purchase, where the offering classes are as follows:

|Offering class|Can modify|Can *exchange*|Can buy and sell in Reserved Instance Marketplace|Price|
|---|---|---|---|---|
|Standard|Yes|No|Yes|$|
|Convertible|Yes|Yes|No|$$$|

##### Modifying a Reserved Instance
[*Modifying*](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ri-modifying.html) a Reserved Instance (Standard or Convertible) involves changing attributes like:

* AZ (within the same region)
* Instance size (within the same instance family and generation)
* Scope (zonal or regional)
* Number of instances

You can split your original Reserved Instances into two or more new Reserved Instances. E.g., Convert a reservation for 10 instances in ap-southeast-2a to:
* A reservation for 3 instances in ap-southeast-2a
* A reservation for 7 instances in ap-southeast-2b

You can also merge two or more Reserved Instances into a single Reserved Instance.

However, there are certain attributes you can't change through *modification*. They include instance family, operating system type and tenancy. However, if you had purchased a Convertible Reserved Instance, then you can change change those attributes through *exchange*.

##### Exchanging a Reserved Instance
[*Exchanging*](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ri-convertible-exchange.html) is possible only for a Convertible Reserved Instance, and means replacing it with another Convertible Reserved Instance that has a different configuration, including instance family, platform, tenancy and scope.

You can exchange as many times as you like, but you must ensure the new Convertible Reserved Instance is of an equal or higher value than the old Convertible Reserved Instance.

On the other hand, Standard Reserved Instances cannot be exchanged but they can be sold on the Reserved Instance Marketplace.

##### Buying a Reserved Instance:
1. Search for *Reserved Instance offerings* from AWS and third-party sellers. To do this, use the EC2 CLI's [describe-reserved-instances-offerings](https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-reserved-instances-offerings.html) operation, where:
    * Instance type: `--instance-type`
    * Scope: `scope` combined with either `--availability-zone` or `--region`
    * Tenancy: `--instance-tenancy`
    * Platform: `--product-description`
    * Whether to buy from Reserved Instance Marketplace: `--include-marketplace` or `--no-include-marketplace`
2. Review the offerings (quotes) that are returned.
3. Proceed with an offering. To do this, use the EC2 CLI's [purchase-reserved-instances-offerings](https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-reserved-instances-offerings.html) operation
4. As purchase prices fluctuate, AWS places a limit on the purchase price. The purchase proceeds only if the total cost does not exceed your quote.

##### Selling a Standard Reserved Instance
You register as a seller, list the Standard Reserved Instances that you want to sell and wait for AWS to automatically sell them to interested buyers.

#### On-Demand Capacity Reservations

Sometimes you might need a guarantee that AWS will always have more capacity for more On-Demand Instances.
AWS doesn't provide that guarantee unless you buy an On-Demand Capacity Reservation, also called just a Capacity Reservation.

You pay the equivalent On-Demand rate whether you use the On-Demand Capacity Reservation or not.

You might need an On-Demand Capacity Reservation in these situations:
* If you anticipate a spike in traffic or business-critical events
* If you want to ensure smooth disaster recovery
* If you need to comply with certain regulations regarding high availability.

When you buy a Capacity Reservation, you must decide on:
* A certain AZ
* Number of instances
* Instance attributes, like instance type, OS and tenancy

Unlike a Reserved Instance or [Savings Plan](https://docs.aws.amazon.com/savingsplans/latest/userguide/what-is-savings-plans.html):
* No term commitment is required for a Capacity Reservation
* No discount is available for the matching On-Demand Instances

#### Spot

A [Spot Instance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-spot-instances.html) is an instance that uses spare EC2 capacity at a steep discount from the On-Demand price. You could get a discount of up to 90%.

The catch is that EC2 might [interrupt](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-interruptions.html) your Spot Instance with a two-minute warning. Interruption results in your Spot Instance either hibernating, stopping or terminating, depending on the choice you made during the purchase of the Spot Instance.

Causes of interruption are:
* Amazon EC2 needs more capacity
* Amazon EC2 needs to perform host maintenance or hardware decommission
* The* Spot price* (the current price of a Spot Instance per hour) is higher than your maximum price. It is optional to specify a maximum price
* Your Spot request has a constraint such as a launch group or an AZ group, and the constraint can no longer be met.

EC2 can send you an *EC2 Instance rebalance recommendation*, that is, a signal that your Spot Instance is at elevated risk of interruption. The signal gives you the chance to proactively rebalance your workload to new or existing Spot Instances that are not at an elevated risk of interruption. To use the signal, you need to enable the Capacity Rebalancing feature of Auto Scaling groups or Spot Fleet.

How to launch a Spot Instance:
* Method 1: Launch one manually using the EC2 console, run-instances AWS CLI command, API, SDK, CloudFormation, etc 
* Method 2: Create an [EC2 Fleet](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-fleet.html) that contains one or more Spot Instances. An EC2 Fleet is a set of instances that meet criteria that you specify, including:
    * Number of On-Demand Instances
    * Number of Spot Instances
    * Types of instances
    * Maximum amount per hour that you're willing to pay for your fleet
    * Allocation strategy, e.g., `price-capacity-optimized`, `diversified`, `lowest-price`
    * Type of request: `instant`, `request` or `maintain`. They specify whether your request is synchronous or asynchronous, and whether EC2 Fleet automatically replenishes interrupted Spot Instances.
* Method 3 (*deprecated* as per [Best practices - Which is the best Spot request method to use](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-best-practices.html#which-spot-request-method-to-use)): Create a [Spot Fleet](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-fleet.html) request. A Spot Fleet a set of Spot Instances and optionally On-Demand Instances. A Spot Fleet is similar to an EC2 Fleet but a key difference is that Spot Fleet lacks the `instant` synchronous request type. Only asynchronous request types are available, that is, `request` and `maintain`.
* Method 4: Create an Auto Scaling group

#### Savings Plan

**TODO** [Savings Plan](https://docs.aws.amazon.com/savingsplans/latest/userguide/what-is-savings-plans.html)

### Instance lifecycle

Terminating

Stopping

Editing a security group or assigning a different security group

### Service limits

Default limits for a particular account:
Five VPCs per region.
5000 SSH key pairs across your account.

### AMIs
