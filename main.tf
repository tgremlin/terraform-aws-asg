terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.66.0"
    }
  }

  backend "s3" {
  bucket = "at-terraform-backends"
  key    = "terraform/awsDemoASG/terraform.tfstate"
  region = "us-east-1"
  }
}

provider "aws" {
  profile = "default"
  region = "us-east-1"
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

resource "aws_vpc" "demo" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "terraform-asg-vpc"
  }
}

resource "aws_subnet" "public1" {
  vpc_id = aws_vpc.demo.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "terraform-asg-public1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id = aws_vpc.demo.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "terraform-asg-public2"
  }
}

resource "aws_subnet" "private1" {
  vpc_id = aws_vpc.demo.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "terraform-asg-private1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id = aws_vpc.demo.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "terraform-asg-private2"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.demo.id

  tags = {
    Name = "terraform-asg-ig"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.demo.id

  tags = {
    Name = "public-route"
  }
}


resource "aws_route" "r" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
  depends_on                = [aws_route_table.public]
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_vpc.demo.default_route_table_id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_vpc.demo.default_route_table_id
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}


resource "aws_security_group" "demo" {
  vpc_id = aws_vpc.demo.id
  tags = {
    Name = "terraform-asg-securitygroup"
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "demo_db" {
  vpc_id = aws_vpc.demo.id
  tags = {
    Name = "terraform-asg-db-securitygroup"
  }

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [ aws_security_group.demo.id ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_launch_configuration" "demo" {
  image_id        = "ami-0ed9277fb7eb570c9"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instance.id]

  user_data = "${file("init.sh")}"

  associate_public_ip_address = true
  key_name = "ssh_key"

  # Required when using a launch configuration with an auto scaling group.
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "demo" {
  launch_configuration = aws_launch_configuration.demo.name

  vpc_zone_identifier  = [ aws_subnet.public1.id, aws_subnet.public2.id ]

  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "instance" {
  name = var.instance_security_group_name
  vpc_id      = aws_vpc.demo.id

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_lb" "demo" {

  name               = var.alb_name

  load_balancer_type = "application"
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.demo.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

resource "aws_lb_target_group" "asg" {

  name = var.alb_name

  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.demo.id
}

resource "aws_security_group" "alb" {

  name = var.alb_security_group_name
  vpc_id      = aws_vpc.demo.id

  # Allow inbound HTTP requests
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = var.sqlusername
  password             = var.sqlpassword
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.selected.name
}

resource "aws_db_subnet_group" "selected" {
  name       = "main"
  subnet_ids = [ aws_subnet.private1.id, aws_subnet.private2.id ]

  tags = {
    Name = "terraform demo DB subnet group"
  }
}