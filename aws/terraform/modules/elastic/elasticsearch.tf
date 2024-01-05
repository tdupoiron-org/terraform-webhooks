resource "aws_ecs_task_definition" "ecs_elasticsearch_task_definition" {
  family                = "tdupoiron-elastic"
  container_definitions = templatefile("${path.module}/task-elasticsearch.json", { aws_owner = var.aws_owner })

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  cpu                      = 2048
  memory                   = 4096

  tags = {
    Name  = "${var.aws_owner}-ecs-task"
    Owner = "${var.aws_owner}"
  }
}

resource "aws_ecs_service" "ecs_service_elasticsearch" {
  name            = "${var.aws_owner}-ecs-service-elasticsearch"
  cluster         = aws_ecs_cluster.ecs_cluster_elastic.id
  task_definition = aws_ecs_task_definition.ecs_elasticsearch_task_definition.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.elastic_subnet.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.elastic_sg.id]
  }

  tags = {
    Name  = "${var.aws_owner}-ecs-service-elasticsearch"
    Owner = "${var.aws_owner}"
  }
}