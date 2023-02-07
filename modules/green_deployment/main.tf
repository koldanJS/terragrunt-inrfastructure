# --------------------------------------------------
# Green Deployment (zero downtime)
# Create:
#   - security group for web server
#   - launch configuration with auto ami lookup
#   - auto scaling group using 2 availability zones
#   - classic load balancer in 2 availability zones
# --------------------------------------------------

resource "aws_security_group" "this" {
  name        = "${var.project_name} Security Group"
  description = "${var.project_name} Security Group for Test App"

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["3.64.155.19/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name} Security Group"
    Owner = "koldanJS"
  }
}

resource "aws_launch_configuration" "this" {
  name_prefix          = "${var.project_name}-Green-Deploy-LC"
  image_id      = data.aws_ami.amazonLinux2_latest.id
  instance_type = var.instance_type
  security_groups = [aws_security_group.this.id]
  user_data = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  name = "ASG-${aws_launch_configuration.this.name}"
  launch_configuration = aws_launch_configuration.this.name
  min_size = 2
  max_size = 2
  min_elb_capacity = 2
  vpc_zone_identifier = [aws_default_subnet.default_subnet1.id, aws_default_subnet.default_subnet2.id]
  health_check_type = "ELB"
  load_balancers = [aws_elb.this.name]

  dynamic "tag" {
    for_each = {
      Name = "Test Green Deploy With Terragrunt"
      Owner = "koldanJS"
    }
    content {
      key = tag.key
      value = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "this" {
  name = "${var.project_name} ELB"
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  security_groups = [aws_security_group.this.id]
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = 80
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 10
  }
  tags = {
    Name = "${var.project_name} ELB"
  }
}

# Don't create a resource, just get subnet id
resource "aws_default_subnet" "default_subnet1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "default_subnet2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}