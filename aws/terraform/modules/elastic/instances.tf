# resource "aws_security_group" "elastic_sg" {
#   vpc_id = aws_vpc.elastic_vpc.id
#   name   = "${var.aws_owner}-elastic-sg"

#   ingress {
#     from_port   = 9200
#     to_port     = 9200
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name  = "${var.aws_owner}-elastic-sg"
#     Owner = var.aws_owner
#   }
# }

# resource "aws_key_pair" "elastic_kp" {
#   key_name   = "${var.aws_owner}_elasticsearch_keypair"
#   public_key = file("~/.ssh/id_rsa.pub")

#   tags = {
#     Name  = "${var.aws_owner}-elastic-kp"
#     Owner = var.aws_owner
#   }
# }

# resource "aws_instance" "elastic_ec2" {
#   ami                         = var.aws_elastic_ami
#   instance_type               = var.aws_elastic_instance_type
#   key_name                    = aws_key_pair.elastic_kp.key_name
#   subnet_id                   = aws_subnet.elastic_subnet.id
#   vpc_security_group_ids      = [aws_security_group.elastic_sg.id]
#   associate_public_ip_address = true


#   tags = {
#    Name  = "${var.aws_owner}-elastic-ec2"
#  Owner = var.aws_owner
#  }
# }

resource "aws_opensearch_domain" "elastic_domain" {
  domain_name    = "${var.aws_owner}-elastic-domain"
  engine_version = "OpenSearch_2.11"
  cluster_config {
    instance_type = "r6g.large.search"
    instance_count = 1
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  tags = {
    Domain  = "${var.aws_owner}-elastic-domain"
    Owner = var.aws_owner
  }
}