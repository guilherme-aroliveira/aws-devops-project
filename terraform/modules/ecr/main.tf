resource "aws_ecr_repository" "ecr_repo" {
  for_each             = toset(var.ecr_images)

  name                 = each.key
  image_tag_mutability = "IMMUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(
    local.tags,
    {
      Name = each.key
    }
  )
}

resource "aws_ecr_lifecycle_policy" "ecr_repo_lifecycle" {
  for_each   = aws_ecr_repository.ecr_repo

  repository = each.value.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire unstagged images"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 1
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Keep only the most recent 30 tagged images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}