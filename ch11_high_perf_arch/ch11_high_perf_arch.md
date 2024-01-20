# Chapter 11 - High-Performing Architectures

## Directing traffic with Elastic Load Balancing

It's a regional construct

You are charged for each hour or partial hour that an ELB is running, plus standard AWS data transfer charges, and usually also the number of "load balancer capacity units" used by the load balancer.

Types:
* Application Load Balancer
* Network Load Balancer
* Gateway Load Balancer
* Classic Load Balancer

## Infrastructure automation

### AWS Elastic Beanstalk

This service takes your code and config settings as input, and then runs your application for you in a load-balanced, scalable, monitored, high-performing way.

### AWS CloudFormation

This service takes a JSON or YAML specification of your AWS resources, and then creates the AWS resources for you. While AWS Elastic Beanstalk deals with application code and config settings, AWS CloudFormation deals with AWS resources, which are lower-level than code.