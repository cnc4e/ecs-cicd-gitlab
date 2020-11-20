resource "aws_cloudwatch_event_rule" "s3" {
  name        = "${var.app_full}-S3-update"
  description = "${var.app_full}-S3-update"

  event_pattern = <<-JSON
  {
    "source": [
      "aws.s3"
    ],
    "detail-type": [
      "AWS API Call via CloudTrail"
    ],
    "detail": {
      "eventSource": [
        "s3.amazonaws.com"
      ],
      "eventName": [
        "PutObject",
        "CompleteMultipartUpload",
        "CopyObject"
      ],
      "requestParameters": {
        "bucketName": [
          "${var.s3_service_settings_bucket_name}"
        ],
        "key": [
          "settings.zip"
        ]
      }
    }
  }
  JSON
}

resource "aws_cloudwatch_event_target" "s3" {
  rule      = aws_cloudwatch_event_rule.s3.name
  target_id = aws_cloudwatch_event_rule.s3.name
  arn       = aws_codepipeline.this.arn
  role_arn  = var.cloudwatch_event_events_role_arn
}

resource "aws_cloudwatch_event_rule" "ecr" {
  name          = "${var.app_full}-ECR-update"
  description   = "${var.app_full}-ECR-update"
  event_pattern = <<-JSON
  {
    "source": [
      "aws.ecr"
    ],
    "detail-type": [
      "ECR Image Action"
    ],
    "detail": {
        "action-type": [
          "PUSH"
        ],
        "image-tag": [
          "latest"
        ],
        "repository-name": [
          ${jsonencode(var.cloudwatch_event_ecr_repository_name)}
        ],
        "result": [
          "SUCCESS"
        ]
    }
  }
  JSON

}

resource "aws_cloudwatch_event_target" "ecr" {
  rule      = aws_cloudwatch_event_rule.ecr.name
  target_id = aws_cloudwatch_event_rule.ecr.name
  arn       = aws_codepipeline.this.arn
  role_arn  = var.cloudwatch_event_events_role_arn
}