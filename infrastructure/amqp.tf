resource "aws_mq_broker" "rabbitmq_broker" {
  broker_name = "rabbitmq_broker"

  engine_type        = "RabbitMQ"
  engine_version     = "3.9.16"
  host_instance_type = "mq.t3.micro"

  user {
    username = "rabbitmq"
    password = "cs302_g1t3!!"
  }

  deployment_mode = "SINGLE_INSTANCE"

  publicly_accessible = true
}
