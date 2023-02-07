variable "instance_type" {
  type        = string
  default = "t2.micro"
  description = "Type of your EC2 instance"
}

variable "instance_name" {
  type        = string
  default = "web"
  description = "Name of your EC2 instance"
}