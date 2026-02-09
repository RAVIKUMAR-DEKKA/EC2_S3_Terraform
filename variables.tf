variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "bucket_name" {
  type    = string
  default = "pavan-2026-s3-demo"
}

variable "object_key_to_download" {
  type    = string
  default = "sample.txt"
}

variable "ami_id" {
  type    = string
  default = "ami-0532be01f26a3de55"
}

variable "instance_type" {
  type    = string
  default = "t2.nano"
}

variable "key_name" {
  type    = string
  default = "my-keypair"
}

variable "ssh_allowed_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

