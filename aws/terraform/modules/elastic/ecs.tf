resource "aws_ecs_cluster" "ecs_cluster_elastic" {
  name = "${var.aws_owner}-ecs-cluster-elastic"

  tags = {
    Name  = "${var.aws_owner}-ecs-cluster-elastic"
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