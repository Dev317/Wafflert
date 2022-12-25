# # Create task definition
# resource "aws_ecs_task_definition" "user_interface_task_definition" {
#   family                = "user_interface"
#   container_definitions = jsonencode([
#   {
#     image = "157077562636.dkr.ecr.us-east-2.amazonaws.com/user_interface_repo:latest",
#     name = "user_interface",
#     essential = true,
#     memory = 200,
#     cpu = 1,
#     environment = [
#         {
#          name = "env"
#          value = "arn:aws:s3:::production-env-g1t3-bucket/user_interface_production.env"
#         }
#     ],
#     portMappings = [
#         {
#           containerPort = 3000
#           hostPort      = 3000
#         }
#       ],
#     logConfiguration = {
#       logDriver = "awslogs",
#       options = {
#             awslogs-group = "ecs_log",
#             awslogs-region= "us-east-2",
#             awslogs-stream-prefix = "ecs"
#           }
#     }
#   }
#   ])
#   requires_compatibilities = ["EC2"]
#   execution_role_arn = aws_iam_role.ecs_tasks_execution_role.arn
#   task_role_arn = aws_iam_role.ecs_tasks_execution_role.arn
# }

# # Create task service
# resource "aws_ecs_service" "user_interface_service" {
#   name            = "user_interface_service"
#   cluster         = aws_ecs_cluster.wafflert.id
#   task_definition = aws_ecs_task_definition.user_interface_task_definition.arn
#   desired_count   = 1
#   launch_type     = "EC2"
#   deployment_minimum_healthy_percent = 100
#   deployment_maximum_percent = 200
# }

resource "aws_s3_object" "user_interface_production_env" {
  key    = "user_interface_production.env"
  bucket = aws_s3_bucket.production_env_bucket.id
  source = var.user_interface_production_env
}
