resource "aws_vpc" "elastic_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name  = "${var.aws_owner}-elastic-vpc"
    Owner = var.aws_owner
  }
}

resource "aws_subnet" "elastic_subnet" {
  vpc_id            = aws_vpc.elastic_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.aws_availability_zone

  tags = {
    Name  = "${var.aws_owner}-elastic-subnet"
    Owner = var.aws_owner
  }
}

resource "aws_internet_gateway" "elastic_igw" {
  vpc_id = aws_vpc.elastic_vpc.id

  tags = {
    Name  = "${var.aws_owner}-elastic-igw"
    Owner = var.aws_owner
  }
}

resource "aws_route_table" "elastic_rtb" {
  vpc_id = aws_vpc.elastic_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.elastic_igw.id
  }

  tags = {
    Name  = "${var.aws_owner}-elastic-rt"
    Owner = var.aws_owner
  }
}

resource "aws_route_table_association" "elastic_rt_association" {
  subnet_id      = aws_subnet.elastic_subnet.id
  route_table_id = aws_route_table.elastic_rtb.id
}

resource "aws_security_group" "elastic_sg" {
  vpc_id = aws_vpc.elastic_vpc.id
  name   = "${var.aws_owner}-elastic-sg"

  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Elasticsearch"
  }
  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Kibana"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "${var.aws_owner}-elastic-sg"
    Owner = var.aws_owner
  }
}