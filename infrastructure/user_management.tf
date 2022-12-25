# Create task definition
resource "aws_ecs_task_definition" "user_management_task_definition" {
  family = "user_management"
  container_definitions = jsonencode([
    {
      image     = "157077562636.dkr.ecr.us-east-2.amazonaws.com/user_management_repo:latest",
      name      = "user_management",
      essential = true,
      memory    = 100,
      cpu       = 1,
      environmentFiles = [
        {
          type  = "s3"
          value = "arn:aws:s3:::production-env-g1t3-bucket/user_management_production.env"
        }
      ],
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
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
resource "aws_ecs_service" "user_management_service" {
  name                               = "user_management_service"
  cluster                            = aws_ecs_cluster.wafflert.id
  task_definition                    = aws_ecs_task_definition.user_management_task_definition.arn
  desired_count                      = 1
  launch_type                        = "EC2"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  lifecycle {
    ignore_changes = [task_definition]
  }
}


resource "aws_s3_object" "user_management_production_env" {
  key    = "user_management_production.env"
  bucket = aws_s3_bucket.production_env_bucket.id
  source = var.user_management_production_env
}
