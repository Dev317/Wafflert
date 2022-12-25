# Create task definition
resource "aws_ecs_task_definition" "telebot_task_definition" {
  family = "telebot"
  container_definitions = jsonencode([
    {
      image     = "157077562636.dkr.ecr.us-east-2.amazonaws.com/telegram_repo:latest",
      name      = "telebot",
      essential = true,
      memory    = 100,
      cpu       = 1,
      environmentFiles = [
        {
          type  = "s3"
          value = "arn:aws:s3:::production-env-g1t3-bucket/telegram_production.env"
        }
      ],
      portMappings = [
        {
          containerPort = 5001
          hostPort      = 5001
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "ecs_log",
          awslogs-region        = "us-east-2",
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
  requires_compatibilities = ["EC2"]
  execution_role_arn       = aws_iam_role.ecs_tasks_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_tasks_execution_role.arn
}

# Create task service
resource "aws_ecs_service" "telebot_service" {
  name                               = "telebot_service"
  cluster                            = aws_ecs_cluster.wafflert.id
  task_definition                    = aws_ecs_task_definition.telebot_task_definition.arn
  desired_count                      = 1
  launch_type                        = "EC2"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  lifecycle {
    ignore_changes = [task_definition]
  }
}


# Create s3 bucket to store production.env file
resource "aws_s3_bucket" "production_env_bucket" {
  bucket = "production-env-g1t3-bucket"
}

resource "aws_s3_bucket_acl" "production_env_bucket_acl" {
  bucket = aws_s3_bucket.production_env_bucket.id
  acl    = "private"
}

resource "aws_s3_object" "telegram_production_env" {
  key    = "telegram_production.env"
  bucket = aws_s3_bucket.production_env_bucket.id
  source = var.telegram_production_env
}
