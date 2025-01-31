# As we will create the organization trail through the API, we need to
# create an Amazon S3 bucket with a policy that allows logging for an
# organization trail. For details, see: 
# https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-create-and-update-an-organizational-trail-by-using-the-aws-cli.html

resource "aws_s3_bucket" "a4l_org_trail_s3_bucket" {
  bucket = local.a4l_org_trail_s3_bucket_name
}

resource "aws_s3_bucket_policy" "a4l_org_trail_s3_bucket_policy" {
  bucket = aws_s3_bucket.a4l_org_trail_s3_bucket.id
  policy - data.aws_iam_policy_document.allow_writing_s3_by_a4l_org_trail
}

data "aws_iam_policy_document" "allow_writing_s3_by_a4l_org_trail" {
  statement {
    sid = "AWSCloudTrailAclCheck"
    principals {
      type = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = ["s3:GetBucketAcl"]
    resources = [local.a4l_org_trail_s3_bucket_arn]
    condition {
      test = "StringEquals"
      variable = "aws:SourceArn"
      values = [local.a4l_org_trail_arn]
    }
  }
  statement {
    sid = "AWSCloudTrailWriteMgmtAcctLogsToOrgTrailBucket"
    principals {
      type = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = ["s3:PutObject"]
    resources = ["${local.a4l_org_trail_s3_bucket_arn}/AWSLogs/${var.a4l_org_management_account_id}/*"]
    condition {
      test = "StringEquals"
      variable = "s3:x-amz-acl"
      values = ["bucket-owner-full-control"]
    }
    condition {
      test = "StringEquals"
      variable = "aws:SourceArn"
      values = [local.a4l_org_trail_arn]
    }
  }
  statement {
    sid = "AWSCloudTrailWriteOrgLogsToOrgTrailBucket"
    principals {
      type = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = ["s3:PutObject"]
    resources = ["${local.a4l_org_trail_arn}/AWSLogs/${var.a4l_org_id}/*"]
    condition {
      test = "StringEquals"
      variable = "s3:x-amz-acl"
      values = ["bucket-owner-full-control"]
    }
    condition {
      test = "StringEquals"
      variable = "aws:SourceArn"
      values = [local.a4l_org_trail_arn]
    }
}
