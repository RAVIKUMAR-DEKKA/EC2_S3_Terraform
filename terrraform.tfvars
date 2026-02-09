aws_region = "us-east-1"

bucket_name            = "pavan-2026-s3-demo"
object_key_to_download = "sample.txt"

ami_id        = "ami-0532be01f26a3de55"
instance_type = "t2.nano"

# Must exist in EC2 -> Key Pairs (in this region)
key_name = "my-keypair"

# Replace with your public IP (recommended). default is 0.0.0.0/0
ssh_allowed_cidr = "0.0.0.0/0"
