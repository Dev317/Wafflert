# Create ECR
resource "aws_ecr_repository" "telegram_repo" {
  name = "telegram_repo"
}

resource "aws_ecr_repository" "user_interface_repo" {
  name = "user_interface_repo"
}

resource "aws_ecr_repository" "users_repo" {
  name = "users_repo"
}

resource "aws_ecr_repository" "payments_repo" {
  name = "payments_repo"
}

resource "aws_ecr_repository" "user_management_repo" {
  name = "user_management_repo"
}

resource "aws_ecr_repository" "orders_repo" {
  name = "orders_repo"
}

resource "aws_ecr_repository" "orders_management_repo" {
  name = "orders_management_repo"
}

resource "aws_ecr_repository" "notifications_repo" {
  name = "notifications_repo"
}

resource "aws_ecr_repository" "bidding_repo" {
  name = "bidding_repo"
}
