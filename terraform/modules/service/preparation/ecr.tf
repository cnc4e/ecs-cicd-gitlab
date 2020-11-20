resource "aws_ecr_repository" "this" {
  for_each = toset(var.ecr_repositories)

  name  = each.value

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(
    {
      "Name" = each.value
    },
    var.tags
  )
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each = toset(var.ecr_repositories)

  repository = aws_ecr_repository.this[each.key].name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 1 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 1
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}