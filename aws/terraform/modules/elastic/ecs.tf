resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.aws_owner}-ecs-cluster"

  tags = {
    Name  = "${var.aws_owner}-ecs-cluster"
    Owner = "${var.aws_owner}"
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "tdupoiron-elastic"
  container_definitions    = <<TASK_DEFINITION
  [
    {
      "name": "tdupoiron-elastic-task",
      "image": "docker.elastic.co/elasticsearch/elasticsearch:8.11.3",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 9200,
          "hostPort": 9200,
          "protocol": "tcp",
          "name": "elastic-http"
        },
        {
          "containerPort": 9300,
          "hostPort": 9300,
          "protocol": "tcp",
          "name": "elastic-cluster"
        }
      ],
      "cpu": 2048,
      "memory": 4096,
      "ulimits": [
        {
          "name": "nofile",
          "softLimit": 1048576,
          "hardLimit": 1048576
        }
      ],
      "environment": [
        {
          "name": "discovery.type",
          "value": "single-node"
        },
        {
          "name": "cluster.name",
          "value": "${var.aws_owner}-elastic"
        },
        {
          "name": "bootstrap.memory_lock",
          "value": "true"
        },
        {
          "name": "ES_JAVA_OPTS",
          "value": "-Xms2g -Xmx2g"
        },
        {
          "name": "xpack.security.enabled",
          "value": "false"
        },
        {
          "name": "ES_NETWORK_HOST",
          "value": "0.0.0.0"
        }
      ],
      "healthCheck": {
        "command": [
          "CMD-SHELL",
          "curl -f http://localhost:9200/_cluster/health || exit 1"
        ],
        "interval": 10,
        "timeout": 5,
        "retries": 3
      },
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/${var.aws_owner}-elastic",
          "awslogs-region": "eu-west-3",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "tags": [
        {
          "key": "Owner",
          "value": "${var.aws_owner}-elastic"
        }
      ]
    }
  ]
  TASK_DEFINITION

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
  cluster         = "${aws_ecs_cluster.ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.ecs_task_definition.arn}"
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