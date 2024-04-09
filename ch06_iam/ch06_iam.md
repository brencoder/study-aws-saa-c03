# Chapter 6 - IAM


## 1.1S1 [Security best practices in IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)

### 1.1S6 Require human users to use federation with an identity provider to access AWS using temporary credentials
"As a best practice, we recommend that you require human users to use federation with an identity provider to access AWS using temporary credentials. If you follow the best practices, you are not managing IAM users and groups. Instead, your users and groups are managed outside of AWS and are able to access AWS resources as a *federated identity*. A federated identity is a user from your enterprise user directory, a web identity provider, the AWS Directory Service, the Identity Center directory, or any user that accesses AWS services by using credentials provided through an identity source. Federated identities use the groups defined by their identity provider. If you are using AWS IAM Identity Center, see [Manage identities in IAM Identity Center](https://docs.aws.amazon.com/singlesignon/latest/userguide/manage-your-identity-source-sso.html) in the AWS IAM Identity Center User Guide for information about creating users and groups in IAM Identity Center."

### Require workloads to use temporary credentials with IAM roles to access AWS
### Require multi-factor authentication (MFA)
### Update access keys when needed for use cases that require long-term credentials
### Follow best practices to protect your root user credentials
### Apply least-privilege permissions
### Get started with AWS managed policies and move toward least-privilege permissions
### Use IAM Access Analyzer to generate least-privilege policies based on access activity
### Regularly review and remove unused users, roles, permissions, policies, and credentials
### Use conditions in IAM policies to further restrict access
### Verify public and cross-account access to resources with IAM Access Analyzer
### Use IAM Access Analyzer to validate your IAM policies to ensure secure and functional permissions
### Establish permissions guardrails across multiple accounts
### Use permissions boundaries to delegate permissions management within an account


## 1.1S2 Flexible authorization model that includes IAM users, groups, roles, and policies

### Root user

Tasks that only root can perform include:
* Close an account
* Change account name, email address, root user password and root user access keys
* Activate IAM access to the Billing and Cost Management console
* Restore IAM user permissions of an IAM administrator user who accidentally revoked their access
* Register as a seller in the Reserved Instance Marketplace
* Enable MFA for S3 Versioning (that is, deleting an object version or changing the versioning state of a bucket)

In some situations, even root might not be all-powerful. For example, suppose your account is a member of an organisation in AWS Organizations and the organization has an SCP that limits permissions of your account. In that case, the restricted permissions apply to all users of your account, even root.

To protect the root user:
* Don't use root unless you absoluately have to
* Enable MFA for root
* Set a strong root password
* Don't create root access keys
* Enable multi-person approval for root user sign-in
* Use CloudWatch or GuardDuty to alert you about root user sign ins
* Use Amazon EventBridge and Amazon SNS to notify you of root user activities

### Password policies for IAM users

Specify minimum length, minimum character types, expiration, lockout settings and whether to allow self-service password reset for IAM user passwords.

Does not apply to the root user or IAM user access keys.

### IAM roles

Like a user but it has no long-term credentials. That is, no username and password, and no access keys. IAM users, AWS resources and even external users authenticated by an IdP service can be given permissions to assume the role temporarily.


## 1.1S3 Role-based access control strategy

## 1.1S5 Resource policies for AWS servces

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


## AWS Security Token Service (STS)
AWS Security Token Service

## Service Control Policies (SCPs)

## IAM Access Analyzer

"IAM Access Analyzer can analyze the services and actions that your IAM roles use, and then generate a fine-grained policy that you can use. After you test each generated policy, you can deploy the policy to your production environment. This ensures that you grant only the required permissions to your workloads. For more information about policy generation, see [IAM Access Analyzer policy generation](https://docs.aws.amazon.com/IAM/latest/UserGuide/access-analyzer-policy-generation.html)."

## IAM Roles Anywhere

## IAM Identity Center

Used to be called AWS Single Sign-On.

Centrally manage identities, permissions, SSO and MFA across your AWS accounts and cloud applications like Salesforce and Microsoft 365.

Can use itself as an IdP or use third-party IdPs like Microsoft Active Directory, Microsoft Entra ID (formerly Azure AD), Okta and Ping Identity.
