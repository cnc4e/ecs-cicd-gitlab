# 自動スケジュール設定
# SSM Automation用のIAM Role
data "aws_iam_policy_document" "gitlab_ssm_automation_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "gitlab_ssm_automation" {
  count = var.cloudwatch_enable_schedule ? 1 : 0

  name               = "${var.pj}-GitLab-SSMautomation"
  assume_role_policy = data.aws_iam_policy_document.gitlab_ssm_automation_trust.json
}

# SSM Automation用のIAM RoleにPolicy付与
resource "aws_iam_role_policy_attachment" "ssm-automation-atach-policy" {
  count = var.cloudwatch_enable_schedule ? 1 : 0

  role       = aws_iam_role.gitlab_ssm_automation.0.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMAutomationRole"
}

# CloudWatchイベント用のIAM Role
data "aws_iam_policy_document" "event_invoke_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "event_invoke_assume_role" {
  count = var.cloudwatch_enable_schedule ? 1 : 0

  name               = "${var.pj}-GitLab-CloudWatchEventRole"
  assume_role_policy = data.aws_iam_policy_document.event_invoke_assume_role.json
}
