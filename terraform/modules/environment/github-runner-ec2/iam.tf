data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "role" {
  name               = "${var.pj}-GitHubRunnerRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = merge(
    {
      "Name" = "${var.pj}-GitHubRunnerRole"
    },
    var.tags
  )
}

data "aws_iam_policy" "systems_manager" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy" "access_ecr" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_policy" "s3objectput" {
  name        = "${var.pj}-s3objectput"
  path        = "/"
  description = "s3にオブジェクトをPUTする"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "systems_manager" {
  role       = aws_iam_role.role.name
  policy_arn = data.aws_iam_policy.systems_manager.arn
}

resource "aws_iam_role_policy_attachment" "access_ecr" {
  role       = aws_iam_role.role.name
  policy_arn = data.aws_iam_policy.access_ecr.arn
}

resource "aws_iam_role_policy_attachment" "s3objectput" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.s3objectput.arn
}

resource "aws_iam_instance_profile" "github_runner" {
  name = "${var.pj}-github-runner-instance-profile"
  role = aws_iam_role.role.name
}
