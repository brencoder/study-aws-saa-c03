# Chapter 6 - IAM

I will read the whole [AWS IAM User Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction_access-management.html).


## 1.1S1 [Security best practices in IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)

* 1.1S6 Require human users to use federation with an identity provider to access AWS using temporary credentials
* Require workloads to use temporary credentials with IAM roles to access AWS
* Require multi-factor authentication (MFA)
* Update access keys when needed for use cases that require long-term credentials
* Follow best practices to protect your root user credentials
* Apply least-privilege permissions
* Get started with AWS managed policies and move toward least-privilege permissions
* Use IAM Access Analyzer to generate least-privilege policies based on access activity
* Regularly review and remove unused users, roles, permissions, policies, and credentials
* Use conditions in IAM policies to further restrict access
* Verify public and cross-account access to resources with IAM Access Analyzer
* Use IAM Access Analyzer to validate your IAM policies to ensure secure and functional permissions
* Establish permissions guardrails across multiple accounts
* Use permissions boundaries to delegate permissions management within an account


## Root user

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

## Password policies for IAM users

Specify minimum length, minimum character types, expiration, lockout settings and whether to allow self-service password reset for IAM user passwords.

Does not apply to the root user or IAM user access keys.

## Permissions boundary

A [permissions boundary](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_boundaries.html) is a list of allowed and denied actions. It is specified in IAM JSON policy format. Every action that is not explicitly allowed in the permissions boundary is denied. If the permissions boundary allows and denies the same action, then the denial takes precedence.

## ABAC

As per [What is ABAC for AWS?](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction_attribute-based-access-control.html), attribute-based access control (ABAC) defines permissions based on tags. You can apply tags to IAM resources and to AWS resources. An ABAC policy grants access to a resource whenever a principal's tag matches a resource's tag.

AWS introduced ABAC in 2018, as per [AWS Security Blog: Simplify granting access to your AWS resources by using tags on AWS IAM users and roles](https://aws.amazon.com/blogs/security/simplify-granting-access-to-your-aws-resources-by-using-tags-on-aws-iam-users-and-roles/).

TODO see [IAM tutorial: Define permissions to access AWS resources based on tags](https://docs.aws.amazon.com/IAM/latest/UserGuide/tutorial_attribute-based-access-control.html)

**Why use ABAC?**

Scalability is the main advantage of ABAC over the traditional model of access to AWS resources, role-based access control (RBAC). As per [What is ABAC for AWS?](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction_attribute-based-access-control.html), less work is required of you even after you add more users to your account or AWS adds more actions to its services. With ABAC, you no longer need to assign new users or groups to roles, and you no longer need to assign new resources to policies.

**Which tags are used in ABAC?**

As per [Services that work with IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_aws-services-that-work-with-iam.html), ABAC tags have one of three condition keys:
* `aws:ResourceTag/<KEY_NAME>`
* `aws:RequestTag/<KEY_NAME>`
* `aws:TagKeys`

**Which AWS services support ABAC?**

As per [Services that work with IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_aws-services-that-work-with-iam.html), some services support all three condition keys for every resource type. They are shown as *Full* below. Others support all three condition keys for only some resource types. They are shown as *Partial* below.

| Service | ABAC full or partial support |
| ------- | ---------------------------- |
| DynamoDB | None |
| EC2 | Full |
| Lambda | Partial |
| SQS | Partial |
| VPC | Full |
| WAF | Full |

## IAM roles

Like a user but it has no long-term credentials. That is, no username and password, and no access keys. IAM users from the current account, IAM users from a different account, AWS services and even external users authenticated by an IdP service can be given permissions to assume the role temporarily.

The steps to create a role depend on whether the role is to be assumed by an IAM user, an AWS service or a federated identiy.

To create a role for an IAM user, you specify:
* *Trusted account*, where:
    * This could be the current account or another account.
    * By default, no users or groups of the trusted account can assume the role. The administrator of the trusted account must attach a policy to the relevant users or groups, where the policy allows for the `sts:assumeRole` action and specifies the role's ARN as the `Resource`.
    * If the account is another account, then you can optionally specify an *external ID*, that is, any word or number that is agreed upon between you and the administrator of the other account.
* Whether the user who wants to assume the role must sign in using *MFA*.
* Which *permissions policies*, if any, to attach to the role.
* Which *permissions boundary*, if any, to attach to the role

To use a role

### Service-linked roles


## Permissions boundaries

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

## Federated identities TODO

As per [AWS IAM Security Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html):

**Require human users to use federation with an identity provider to access AWS using temporary credentials**

"As a best practice, we recommend that you require human users to use federation with an identity provider to access AWS using temporary credentials. If you follow the best practices, you are not managing IAM users and groups. Instead, your users and groups are managed outside of AWS and are able to access AWS resources as a *federated identity*. A federated identity is a user from your enterprise user directory, a web identity provider, the AWS Directory Service, the Identity Center directory, or any user that accesses AWS services by using credentials provided through an identity source. Federated identities use the groups defined by their identity provider. If you are using AWS IAM Identity Center, see [Manage identities in IAM Identity Center](https://docs.aws.amazon.com/singlesignon/latest/userguide/manage-your-identity-source-sso.html) in the AWS IAM Identity Center User Guide for information about creating users and groups in IAM Identity Center."

The identities could come from:
* Your corporate directory (e.g., Microsoft Active Directory, Okta or Microsoft Entra ID). This could involve SAML 2.0 or an identity broker, like Keycloak.
* An Internet identity provider, for access from mobile apps or web apps (e.g., Amazon, Facebook, Google or an OpenID Connect compatible identity provider). This could involve Amazon Cognito

## Resource-based policies TODO

## AWS Security Token Service (STS) TODO
AWS Security Token Service

## Service Control Policies (SCPs) TODO

## IAM Access Analyzer

"IAM Access Analyzer can analyze the services and actions that your IAM roles use, and then generate a fine-grained policy that you can use. After you test each generated policy, you can deploy the policy to your production environment. This ensures that you grant only the required permissions to your workloads. For more information about policy generation, see [IAM Access Analyzer policy generation](https://docs.aws.amazon.com/IAM/latest/UserGuide/access-analyzer-policy-generation.html)."

## IAM Roles Anywhere

## IAM Identity Center TODO

Used to be called AWS Single Sign-On.

Centrally manage identities, permissions, SSO and MFA across your AWS accounts and cloud applications like Salesforce and Microsoft 365.

Can use itself as an IdP or use third-party IdPs like Microsoft Active Directory, Microsoft Entra ID (formerly Azure AD), Okta and Ping Identity.
