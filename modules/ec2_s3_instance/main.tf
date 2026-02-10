# Default VPC and subnet
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security group (SSH only)
resource "aws_security_group" "ssh_only" {
  name   = "ec2-ssh-only-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# IAM role for S3 read
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "ec2-s3-read-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Using direct bucket name for IAM policy resources
data "aws_iam_policy_document" "s3_read" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::pavan-2026-s3-demo/*"]
  }
}

resource "aws_iam_policy" "s3_read" {
  name   = "ec2-s3-read-policy"
  policy = data.aws_iam_policy_document.s3_read.json
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_read.arn
}

resource "aws_iam_instance_profile" "profile" {
  role = aws_iam_role.ec2_role.name
}

# EC2 instance
resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.ssh_only.id]
  iam_instance_profile        = aws_iam_instance_profile.profile.name
  associate_public_ip_address = true
  key_name                    = var.key_name

  # User data updated with direct bucket name string
  user_data = <<-EOF
    #!/bin/bash
    yum install -y awscli
    mkdir -p /home/ec2-user/s3-downloads
    aws s3 cp s3://pavan-2026-s3-demo/${var.object_key_to_download} \
      /home/ec2-user/s3-downloads/${var.object_key_to_download}
    chown -R ec2-user:ec2-user /home/ec2-user/s3-downloads
  EOF

  tags = {
    Name = "EC2_S3_Download"
  }
}
