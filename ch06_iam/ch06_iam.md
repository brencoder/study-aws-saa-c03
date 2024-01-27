# Chapter 6 - IAM

# Root user

TODO Tasks that only root can perform

TODO Protect root user

## Password policies

TODO ## Password policies

## IAM roles

Like a user but it has no long-term credentials. That is, no username and password, and no access keys. IAM users, AWS resources and even external users authenticated by an IdP service can be given permissions to assume the role temporarily.

## Cross-account IAM roles

## AWS managed job function policies

### SystemAdministrator policy

Is a big allowlist.

Notes:
- Cannot create network ACLs but can delete them.
- Cannot manage transit gateways at all

See: https://docs.aws.amazon.com/aws-managed-policy/latest/reference/SystemAdministrator.html

### PowerUserAccess policy

Is a very small denylist:

    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "NotAction": [
                    "iam:*",
                    "organizations:*",
                    "account:*"
                ],
                "Resource": "*"
            },
            {
                "Effect": "Allow",
                "Action": [
                    "iam:CreateServiceLinkedRole",
                    "iam:DeleteServiceLinkedRole",
                    "iam:ListRoles",
                    "organizations:DescribeOrganization",
                    "account:ListRegions"
                ],
                "Resource": "*"
            }
        ]
    }

## Types of identity management

TODO types of identity management

TODO Federated identity management

## IAM Identity Centre (AWS Single Sign-On)

TODO IAM Identity Centre (AWS Single Sign-On)