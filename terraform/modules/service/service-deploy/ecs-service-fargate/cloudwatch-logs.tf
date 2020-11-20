resource "aws_cloudwatch_log_group" "container_log_group" {
  for_each = toset(var.clowdwatch_log_groups)

  name              = each.value
  retention_in_days = 3

  tags = merge(
    {
      "Name" = each.value
    },
    var.tags
  )
}