resource "aws_eip" "gitlab" {
  instance = aws_instance.gitlab.id
  vpc = true

  tags = merge(
    {
      "Name" = "${var.pj}-gitlab-eip"
    },
    var.tags
  )
}