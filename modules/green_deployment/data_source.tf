data "aws_availability_zones" "available" {}
# Suits only for eu-central-1
data "aws_ami" "amazonLinux2_latest" {
  owners = ["137112412989"]
  most_recent = true
  filter {
    name = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}