terraform {
  backend "s3" {
    bucket = "pavan-s3-terraform-state"
    key    = "ec2-setup/terraform.tfstate"
    region = "us-east-1"
  }
}
