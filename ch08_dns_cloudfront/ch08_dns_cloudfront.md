# DNS

## Route 53 routing policies

* Latency-based routing: Direct traffic based on AWS' data about latency between the user and AWS data centres
* Geolocation DNS: Direct traffic based on where the customer is located 
* Geoproximity routing: Direct traffic based on the geographic location of the user
* Weighted round robin: Direct traffic based on weights that you specify

You might wonder how AWS determines the location of the user for latency-based routing and geoproximity routing. If the user's DNS resolver supports the *edns-client-subnet* extension of EDNS0, described in [RFC 7871](https://www.rfc-editor.org/rfc/rfc7871), then Route 53 determines the user's location based on the edns-client-subnet extension. Otherwise, the user's DNS resolved sends a truncated version of the user's IP address to Route 53, and Route 53 determins the user's location based on that.

## Using Route 53 with CloudFront

CloudFront has a global network of edge locations, where edge locations return cached copies of your static or dynamic web content to users. In CloudFront, you create a *distribution*. Then, you either direct users to the domain name that CloudFront automatically assigned to your distribution (see [here](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/LinkFormat.html)), or you create an *alias record* in Route 53, pointing to your distribution (see [here](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-to-cloudfront-distribution.html)).