# Chapter 6. IAM

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
