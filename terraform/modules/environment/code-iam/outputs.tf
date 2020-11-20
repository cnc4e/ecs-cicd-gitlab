output "deploy_role_arn" {
  value = aws_iam_role.codedeploy.arn
}

output "pipeline_role_arn" {
  value = aws_iam_role.codepipeline.arn
}

output "events_role_arn" {
  value = aws_iam_role.events.arn
}

output "events_role_name" {
  value = aws_iam_role.events.name
}