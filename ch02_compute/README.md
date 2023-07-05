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

Cluster:
* What is it?
    * Puts instances close together inside an AZ.
    * Can span multiple peered VPCs in the same region.
* Why use it?
    * Good for workloads requiring low network latency, high network throughput or both.
    * Suitable workloads include high-performance computing (HPC) applications.
* Tips for avoiding "insufficient capacity error":
    * Use a single request to launch all instances of a cluster placement group.
    * Use a common instance type for all instances in a cluster placement group.

Partition:

* What is it?
    * Spreads instances across logical partitions. You number the partitions 1, 2, 3, and so on, up to a maximum of 7.
    * Amazon EC2 ensures that each partition has its own set of racks. So, the impact of a single hardware failure affects just one partition.
* Why use it?
    * Good for reducing the likelihood of correlated hardware failures for your application.
    * Suitable workloads involve large distributed and replicated processing. For example, Hadoop, where a network of many computers solves a problem involving massive amounts of data and computation.

Spread:

* What is it?
    * A group of instances where each instance is placed on distinct hardware.
* Why use it?
    * Good for applications that have a few important instances that must be kept separate from each other.
    * Reduce the risk of correlated failures when instances share the same equipment.
* Two types of spread placement groups:
    * Rack spread level placement groups - e.g., where seven instances in a common AZ are placed on seven different racks, where each rack has its own network and power source.
    * Host level spread level placement groups - only available with [AWS Outputs](https://docs.aws.amazon.com/outposts/latest/userguide/what-is-outposts.html), where AWS Outputs is a fully managed service where AWS operates that part of your on-premises datacentre as part of an AWS region

Difference between partition and spread:
* No two instances of a spread placement group will ever be on the same hardware.
* With partition placement groups, no two *partitions* will ever be on the same hardware. However, two instances of a single partition could be on the same hardware.

### Instance pricing

Models: on-demand, reserved, spot, AWS Savings Plan and scheduled.

On-demand:
* Pay per hour or per second, with a minimum spend of 60 seconds.

Reserved:
* Get a discount on instances that certain instance attributes:
    * Instance type: E.g., `t2.micro` or `c7gn.xlarge`
    * Region
    * Availability Zone
    * Tenancy: shared, Dedicated Instance or Dedicated Host
    * Platform: which OS.
* Term commitment:
    * One year
    * Three years
* When the term of a Reserved Instance expires, you continue using its EC2 instance at on-demand rates until you terminate the instances or purchase new Reserved Instances that match the instance attributes.
* Payment options:
    * All upfront
    * Partial upfront
    * No upfront
* [Offering class](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/reserved-instances-types.html):
    * Standard: can be modified but not exchanged.
    * Convertible: can be modified or exchanged. Due to the extra flexibility, Convertible Reserved Instances ore expensive than Standard Reserved Instances.
    * TODO


Spot

### Instance lifecycle

Terminating

Stopping

Editing a security group or assigning a different security group

### Service limits

Default limits for a particular account:
Five VPCs per region.
5000 SSH key pairs across your account.

## AMIs