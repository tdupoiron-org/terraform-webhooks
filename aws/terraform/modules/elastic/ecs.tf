resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.aws_owner}-ecs-cluster"

  tags = {
    Name  = "${var.aws_owner}-ecs-cluster"
    Owner = "${var.aws_owner}"
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
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

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "${var.aws_owner}-ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = {
    Name  = "${var.aws_owner}-ecs-taskExecutionRole"
    Owner = "${var.aws_owner}"
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_service" "elastic_service" {
  name            = "${var.aws_owner}-elastic-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.elastic_subnet.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.elastic_sg.id]
  }

  tags = {
    Name  = "${var.aws_owner}-elastic-service"
    Owner = "${var.aws_owner}"
  }
}