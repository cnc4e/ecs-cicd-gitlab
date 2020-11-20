resource "aws_dlm_lifecycle_policy" "dlm-lifecycle-policy-gitlab" {
  count = var.dlm_enable_snapshot ? 1 : 0

  description        = "${var.pj}-gitlab-daily-snapshot"
  execution_role_arn = "arn:aws:iam::${data.aws_caller_identity.self.account_id}:role/service-role/AWSDataLifecycleManagerDefaultRole"
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]
    schedule {
      name = "${var.pj}-gitlab-snapshot"
      create_rule {
        interval      = 24
        interval_unit = "HOURS"
        times         = [var.dlm_snaphost_time]
      }
      retain_rule {
        count = var.dlm_snaphost_count
      }  
      copy_tags = true
    }
    target_tags = {
      Name = "${var.pj}-gitlab-ebs"
    }
  }

  tags = merge(
    {
      "Name" = "${var.pj}-gitlab-dlm"
    },
    var.tags
  )
}