# before
resource "aws_s3_bucket" "service_settings" {
  bucket        = var.s3_service_settings_bucket_name
  acl           = "private"
  force_destroy = true

  tags = merge(
    {
      "Name" = var.s3_service_settings_bucket_name
    },
    var.tags
  )

  versioning {
    enabled = true
  }

}
