resource "aws_s3_bucket" "artifact_store" {
  bucket        = var.s3_artifact_store_name
  acl           = "private"
  force_destroy = true

  tags = merge(
    {
      "Name" = var.s3_artifact_store_name
    },
    var.tags
  )

}

# after
resource "aws_s3_bucket" "cloudtraile" {
  bucket        = "${var.app_full}-cloudtraile"
  acl           = "private"
  force_destroy = true

  tags = merge(
    {
      "Name" = "${var.app_full}-cloudtraile"
    },
    var.tags
  )

}

data "aws_caller_identity" "self" { }

# CloudtrailからS3を更新できるようにするバケットポリシー
resource "aws_s3_bucket_policy" "cloudtraile" {
  bucket = aws_s3_bucket.cloudtraile.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${var.app_full}-cloudtraile"
        },
        {
            "Sid": "AWSCloudTrailWrite20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.app_full}-cloudtraile/AWSLogs/${data.aws_caller_identity.self.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY

  depends_on = [aws_s3_bucket.cloudtraile]
}