output "ecs_task_execute_arn" {
  value = aws_iam_role.ecs_task_execute.arn
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.this.arn
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.this.name
}