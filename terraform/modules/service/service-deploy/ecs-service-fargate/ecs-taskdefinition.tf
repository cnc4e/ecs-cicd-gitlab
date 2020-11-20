data "aws_region" "current" {}

resource "aws_ecs_task_definition" "this" {
  family                   = "dummy"
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  execution_role_arn = var.task_execution_role_arn

  container_definitions = <<-JSON
  [
    {
      "name": "dummy",
      "image": "nginx:1.12",
      "essential": true,
      "portMappings": [
        {
          "hostPort": 80,
          "protocol": "tcp",
          "containerPort": 80
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/${var.pj}-cluster/${var.app}",
          "awslogs-region": "${data.aws_region.current.name}",
          "awslogs-stream-prefix": "dummy"
        }
      }
    }
  ]
  JSON

  tags = merge(
    {
      "Name" = "dummy"
    },
    var.tags
  )
}