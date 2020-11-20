resource "aws_ecs_cluster" "this" {
  name = var.cluster_name

  tags = merge(
    {
      "Name" = var.cluster_name
    },
    var.tags
  )
}