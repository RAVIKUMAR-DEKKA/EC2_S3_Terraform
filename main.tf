provider "aws" {
  region = var.aws_region
}

module "ec2_s3_instance" {
  source = "./modules/ec2_s3_instance"

  bucket_name            = var.bucket_name
  object_key_to_download = var.object_key_to_download
  ami_id                 = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  ssh_allowed_cidr       = var.ssh_allowed_cidr
}

output "instance_id" {
  value = module.ec2_s3_instance.instance_id
}

output "public_ip" {
  value = module.ec2_s3_instance.public_ip
}
