[comment]: # (Begin TF Docs)
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.66.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.66.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.demo](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/autoscaling_group) | resource |
| [aws_db_instance.default](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.selected](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/db_subnet_group) | resource |
| [aws_internet_gateway.gw](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/internet_gateway) | resource |
| [aws_launch_configuration.demo](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/launch_configuration) | resource |
| [aws_lb.demo](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/lb) | resource |
| [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.asg](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/lb_target_group) | resource |
| [aws_route.r](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/route) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/route_table) | resource |
| [aws_route_table_association.private1](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private2](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public1](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public2](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/route_table_association) | resource |
| [aws_security_group.alb](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/security_group) | resource |
| [aws_security_group.demo](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/security_group) | resource |
| [aws_security_group.demo_db](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/security_group) | resource |
| [aws_security_group.instance](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/security_group) | resource |
| [aws_subnet.private1](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/subnet) | resource |
| [aws_subnet.private2](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/subnet) | resource |
| [aws_subnet.public1](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/subnet) | resource |
| [aws_subnet.public2](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/subnet) | resource |
| [aws_vpc.demo](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_name"></a> [alb\_name](#input\_alb\_name) | The name of the ALB | `string` | `"terraform-asg-example"` | no |
| <a name="input_alb_security_group_name"></a> [alb\_security\_group\_name](#input\_alb\_security\_group\_name) | The name of the security group for the ALB | `string` | `"terraform-example-alb"` | no |
| <a name="input_instance_security_group_name"></a> [instance\_security\_group\_name](#input\_instance\_security\_group\_name) | The name of the security group for the EC2 Instances | `string` | `"terraform-example-instance"` | no |
| <a name="input_server_port"></a> [server\_port](#input\_server\_port) | The port the server will use for HTTP requests | `number` | `80` | no |
| <a name="input_sqlpassword"></a> [sqlpassword](#input\_sqlpassword) | SQL DB admin password | `string` | n/a | yes |
| <a name="input_sqlusername"></a> [sqlusername](#input\_sqlusername) | SQL DB admin username | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | The domain name of the load balancer |
[comment]: # (End TF Docs)