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

## Principals

A principal is an IAM resource that can authenticate to IAM. Users, roles and the root user are the only three types of IAM entities. Groups are not a type of principal.

## Group

Also called a *user group*. It is a set of users. You can assign policies to a group but you cannot authenticate as a group, and you cannot reference a group as a principal in an IAM policy.

As [IAM user groups (amazon.com)](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups.html) says, "You cannot identify a user group as a Principal in a policy (such as a resource-based policy) because groups relate to permissions, not authentication, and principals are authenticated IAM entities."

Also, groups cannot be nested. A group can contain users but not other groups.

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

### Use cases for roles

* *Federated user access* - To assign permissions to a federated identity.
* *Temporary IAM user/role permissions* - So am IAM user or roleto temporarily take on different permissions for a specific task.
* *Cross-account access* - To allow an AWS service to use features from other AWS services. In particular:
    * *Forward access sessions (FAS)* - To allow a service to fulfil an IAM user/role's request that requires calling another AWS service. For example, to allow S3 to fulfil an S3 *PutObject* request in a bucket where SSE-KMS encryption is enabled.
    * *AWS service role* - A type of IAM role that an AWS service assumes to perform actions on your behalf. An IAM administrator (or anyone having the *iam:CreateServiceLinkedRole* permission on resource "arn:aws:iam::*:role/aws-service-role/*") can create, modify and delete an AWS service role. An AWS service role can grant permissions relating to multiple AWS services. An IAM instance profile is an example of an AWS service role. For example, an IAM instance profile that allows EC2 to list an S3 bucket and log to CloudWatch Logs.
    * *AWS service-linked role* - A type of service role that is linked to an AWS service. Only the AWS service can assume one of its service-linked roles. No other users or roles can assume the service's service-linked roles. A service-linked role is owned by an AWS service and managed by AWS. An IAM administrator can view but not edit the permissions of a service-linked role. For example, see [Service-linked role for Spot Instance requests](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/service-linked-roles-spot-instance-requests.html). Some AWS services fully support service-linked roles (e.g., [Auto Scaling](https://docs.aws.amazon.com/autoscaling/ec2/userguide/autoscaling-service-linked-role.html)), others partially support it (e.g., EC2) and others do not support it at all (e.g., DynamoDB). See: [Services that work with IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_aws-services-that-work-with-iam.html#all_svcs).

### Naming roles

* Role names must be unique within an AWS account.
* Case cannot be used to make a role name unique.
* Although a role name is case-sensitive when used in a policy or as part of an ARN, a role is case insensitive when specified in the 'assume role' window of the AWS Management Console.
* You can't rename a role after it has been created because other entities might refer to the role.

### Permitting a user to pass a role to an AWS service

You pass a role to an AWS service if you need an AWS service to assume the role later to perform actions on your behalf. For example, you can attach an IAM permissions policy to an IAM user, where the IAM permissions policy allows the user to pass a specified role to EC2, where:

* The role's permissions policy grants certain permissions
* The role's trust policy allows the EC2 service to assume the role

As [Grant a user permissions to pass a role to an AWS service](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_passrole.html) says, "A user can pass a role ARN as a parameter in any API operation that uses the role to assign permissions to the service. The service then checks whether that user has the iam:PassRole permission. To limit the user to passing only approved roles, you can filter the iam:PassRole permission with the Resources element of the IAM policy statement."

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
