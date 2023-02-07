variable "instance_type" {
  type        = string
  default = "t2.micro"
  description = "Type of your EC2 instance"
}

variable "project_name" {
  type        = string
  default = "web"
  description = "Name of your project"
}

variable "ingress_ports" {
  type        = list
  default     = ["80", "443"]
  description = "Enter Opend Ports"
}