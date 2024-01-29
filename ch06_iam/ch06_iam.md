# Chapter 6 - IAM

# Root user

Key thats that only root can perform are:
* Close an account
* Change account name, email address, root user password and root user access keys
* Restore IAM user permissions of an IAM administrator user who accidentally revoked their access
* Register as a seller in the Reserved Instance Marketplace
* Enable MFA for S3 Versioning (that is, deleting an object version or changing the versioning state of a bucket)

To protect the root user:
* Don't use root unless you absoluately have to
* Enable MFA for root
* Set a strong root password
* Don't create root access keys
* Enable multi-person approval for root user sign-in
* Use CloudWatch or GuardDuty to alert you about root user sign ins
* Use Amazon EventBridge and Amazon SNS to notify you of root user activities

## Password policies for IAM users

Specify minimum length, minimum character types, expiration, lockout settings and whether to allow self-service password reset for IAM user passwords.

Does not apply to the root user or IAM user access keys.

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

Types of identity management:
* IAM users
* IAM Identity Center (for users managed by AWS Organizations)
* Amazon Cognito identity pools
* Federated users via identity providers, where:
    * Web identity providers like Amazon, Facebook and Google support federation through the OpenID Connect (OIDC) protocol.
    * Other identity providers like Active Directory Federation Services and Keycloak support federation through the SAML 2.0 protocol

## Amazon Cognito

A service that can authenticate user access to your web/mobile applications and AWS resources. The authentication can be delegated to a third-party IdP. Amazon Cognito can act as a layer of abstraction between IdPs and your application.

See [Common Amazon Cognito scenarios](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-scenarios.html)

## IAM Identity Centre

Used to be called AWS Single Sign-On.

Centrally manage identities, permissions, SSO and MFA across your AWS accounts and cloud applications like Salesforce and Microsoft 365.

Can use itself as an IdP or use third-party IdPs like Microsoft Active Directory, Microsoft Entra ID (formerly Azure AD), Okta and Ping Identity.