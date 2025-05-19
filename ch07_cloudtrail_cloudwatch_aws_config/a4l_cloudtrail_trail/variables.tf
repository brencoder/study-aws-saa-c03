variable "a4l_org_id" {
  description = "ID of the Animals 4 Life organization"
  type        = string
}

variable "a4l_org_management_account_id" {
  description = "AWS account ID of the management account of the Animals 4 Life organization"
  type        = string
}

variable "a4l_org_trail_name" {
  description = "Name of the organization trail of the Animals 4 Life organization"
  type        = string
  default     = "Animals4lifeORG"
}

variable "a4l_org_trail_home_region" {
  description = "Name of the home region of the organization trail of the Animals 4 Life organization"
  type        = string
  default     = "ap-southeast-2"
}

variable "a4l_org_trail_iam_role_name" {
  description = "Name of the IAM role assigned to the organization trail of the Animals 4 Life organization"
  type        = string
  default     = "CloudTrailRoleForCloudWatchLogs_Animals4life"
}

variable "a4l_org_trail_s3_bucket_name" {
  description = "Name of the S3 bucket of the organization trail of the Animals 4 Life organization"
  type        = string
  default     = "cloudtrail-animals4life-bk-1234567"
}

variable "a4l_org_trail_log_group_name" {
  description = "Name of the CloudWatch Logs log group of the organization trail of the Animals 4 Life organization"
  type        = string
  default     = "aws-cloudtrail-logs-animals4life-org"
}

locals {
  "a4l_org_trail_arn" = "arn:aws:cloudtrail:${a4l_org_trail_home_region}:${var.a4l_org_management_account_id}:trail:trail/${a4l_org_trail_name}"
  "a4l_org_trail_iam_role_arn"  = "arn:aws:iam::${var.a4l_org_management_account_id}:role/${var.a4l_org_trail_iam_role_name}"
  "a4l_org_trail_log_group_arn" = "arn:aws:logs:${a4l_org_trail_home_region}:${var.a4l_org_management_account_id}:log-group:CloudTrail/${a4l_org_trail_log_group_name}"
  "a4l_org_trail_s3_bucket_arn" = "arn:aws:s3:::${a4l_org_trail_s3_bucket_name}"
}
