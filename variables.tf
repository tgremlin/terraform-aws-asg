variable region {
  type        = string
  description = "AWS Region to deploy resources too"
}


variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 80
}

variable "alb_name" {
  description = "The name of the ALB"
  type        = string
  default     = "terraform-asg-example"
}

variable "instance_security_group_name" {
  description = "The name of the security group for the EC2 Instances"
  type        = string
  default     = "terraform-example-instance"
}

variable "alb_security_group_name" {
  description = "The name of the security group for the ALB"
  type        = string
  default     = "terraform-example-alb"
}

variable sqlpassword {
  type        = string
  description = "SQL DB admin password"
  sensitive = true
}

variable sqlusername {
  type        = string
  description = "SQL DB admin username"
  sensitive = true
}
