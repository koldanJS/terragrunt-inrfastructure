output "available_aws_availability_zones" {
  value = data.aws_availability_zones.available.names
}

output "latest_amazonLinux_ami_id" {
  value = data.aws_ami.amazonLinux2_latest.id
}

output "load_balancer_url" {
  value = aws_elb.this.dns_name
}