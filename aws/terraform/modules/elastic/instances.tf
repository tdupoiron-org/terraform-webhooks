resource "aws_security_group" "elastic_sg" {
  vpc_id = aws_vpc.elastic_vpc.id
  name   = "${var.aws_owner}-elastic-sg"

  # ingress {
  #   from_port   = 9200
  #   to_port     = 9200
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
  # ingress {
  #   from_port   = 9300
  #   to_port     = 9300
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    ipv6_cidr_blocks = ["::/0"]
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

# # resource "aws_key_pair" "elastic_kp" {
# #   key_name   = "${var.aws_owner}_elasticsearch_keypair"
# #   public_key = file("~/.ssh/id_rsa.pub")

# #   tags = {
# #     Name  = "${var.aws_owner}-elastic-kp"
# #     Owner = var.aws_owner
# #   }
# # }

# # resource "aws_instance" "elastic_ec2" {
# #   ami                         = var.aws_elastic_ami
# #   instance_type               = var.aws_elastic_instance_type
# #   key_name                    = aws_key_pair.elastic_kp.key_name
# #   subnet_id                   = aws_subnet.elastic_subnet.id
# #   vpc_security_group_ids      = [aws_security_group.elastic_sg.id]
# #   associate_public_ip_address = true


# #   tags = {
# #    Name  = "${var.aws_owner}-elastic-ec2"
# #  Owner = var.aws_owner
# #  }
# # }

# resource "aws_opensearch_domain" "elastic_domain" {
#   domain_name    = "${var.aws_owner}-elastic-domain"
#   engine_version = "OpenSearch_2.11"
#   cluster_config {
#     instance_type = "r6g.large.search"
#     instance_count = 1
#   }

#   advanced_security_options {
#     enabled = true
#     internal_user_database_enabled = true
#     anonymous_auth_enabled = false
#     master_user_options {
#       master_user_name     = var.aws_elastic_master_username
#       master_user_password = "tdup_Aout87"
#     }
#   }

#   node_to_node_encryption {
#     enabled = true
#   }

#   encrypt_at_rest {
#     enabled = true
#   }

#   domain_endpoint_options {
#     enforce_https       = true
#     tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
#   }

#   ebs_options {
#     ebs_enabled = true
#     volume_size = 10
#   }

#   tags = {
#     Domain  = "${var.aws_owner}-elastic-domain"
#     Owner = var.aws_owner
#   }
# }