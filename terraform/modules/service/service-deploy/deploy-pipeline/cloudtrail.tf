resource "aws_cloudtrail" "this" {
  name           = "${var.app_full}-cloudtraile"
  s3_bucket_name = aws_s3_bucket.cloudtraile.id
  
  event_selector {
      data_resource {
        type   = "AWS::S3::Object"
        values = ["${var.s3_service_settings_bucket_arn}/"]
      }
  }

  depends_on = [aws_s3_bucket_policy.cloudtraile]
}