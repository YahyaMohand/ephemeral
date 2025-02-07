resource "aws_ecr_repository" "this" {
  name                 = local.name
  image_tag_mutability = "MUTABLE"
  force_delete         = false

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = <<EOF
  {
    "rules": [
      {
        "rulePriority": 10,
        "description": "Keep last 1N images",
        "selection": {
          "tagStatus": "any",
          "countType": "imageCountMoreThan",
          "countNumber": ${local.ecr_images_lifetime}
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
  EOF
}
