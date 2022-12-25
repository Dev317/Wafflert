# Create ECS cluster
resource "aws_ecs_cluster" "wafflert" {
  name = "wafflert"
  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.ecs_log.name
      }
    }
  }
}

# Logging for ECS
resource "aws_cloudwatch_log_group" "ecs_log" {
  name              = "ecs_log"
  retention_in_days = 0
}

resource "aws_cloudwatch_log_stream" "ecs_log_stream" {
  name           = "ecs_log_stream"
  log_group_name = aws_cloudwatch_log_group.ecs_log.name
}


resource "aws_ecs_capacity_provider" "ec2_cap_provider" {
  name = "ec2_cap_provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.analysis_ecs_asg.arn
  }
}

resource "aws_ecs_cluster_capacity_providers" "wafflert" {
  cluster_name = aws_ecs_cluster.wafflert.name

  capacity_providers = [aws_ecs_capacity_provider.ec2_cap_provider.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.ec2_cap_provider.name
  }
}

# Create iam policy and role for autoscaling
resource "aws_iam_role" "ecs_agent" {
  name               = "ecs-agent"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "ecs-agent"
  role = aws_iam_role.ecs_agent.name
}


# Create autoscaling group
resource "aws_launch_configuration" "ecs_launch_config" {
  image_id                    = "ami-0b0033935e98632de"
  iam_instance_profile        = aws_iam_instance_profile.ecs_agent.name
  security_groups             = [aws_security_group.ecs_sg.id]
  user_data                   = <<EOF
#!/bin/bash
sudo yum update -y
sudo echo 'ECS_CLUSTER=wafflert' >> /etc/ecs/ecs.config
sudo echo 'ECS_DISABLE_PRIVILEGED=true' >> /etc/ecs/ecs.config
EOF
  instance_type               = "t2.micro"
  associate_public_ip_address = "true"
}

resource "aws_autoscaling_group" "analysis_ecs_asg" {
  name                 = "asg"
  vpc_zone_identifier  = [aws_subnet.public_subnet.id]
  launch_configuration = aws_launch_configuration.ecs_launch_config.name

  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
}


# Create iam role and policy to execute ECS task and access to s3 bucket for production env
data "aws_iam_policy_document" "ecs_tasks_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_tasks_execution_role" {
  name               = "ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_execution_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_tasks_execution_role" {
  role       = aws_iam_role.ecs_tasks_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "s3-bucket-access" {
  name        = "s3-bucket-access"
  description = "Allows access to s3 bucket"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "arn:aws:s3:::*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.ecs_tasks_execution_role.name
  policy_arn = aws_iam_policy.s3-bucket-access.arn
}
