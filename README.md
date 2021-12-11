# Terraform AWS Web Server with autoscaling and loadbalancer

This repository will generate 2 web servers using a launch configuration template and an autoscaling group into a cusotm VPC. Pull requests and merges to the master branch will trigger a pipeline in CircleCI that will apply the resources to AWS. To use this repository, you will need the following:

1. A [CircleCI Account](https://circleci.com/)
2. [AWS IAM User](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html) with proper permissions (policy will be included in future update)
3. Fork this repository to your github account
4. Setup the [CircleCI project](https://circleci.com/docs/2.0/project-build/)
5. After you have followed the project, click in the top right corner on the gear icon of the project (Project Settings) ![CircleCIProjectSettings](/images/circleci1.png)
6. Click "Environment Variables" and the the following 5 environment variables:
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - AWS_DEFAULT_REGION
  - sqlusername
  - sqlpassword
  ![CircleCIEnvironmentVariables](/images/circleci2.png)
7. By default, CircleCI pipeline will execute on any commit to the repository. If you do not wish for it to run on every commit, you can go to "Project Settings --> Advanced"      and toggle the "Only build on pull requests". ![CircleCIOnlyBuildPR](/images/circleci3.png)
8. This pipeline is built to have multiple stages, two of which will require a human approval to proceed to next step (Apply and Destroy). This gives a chance to review changes 
   to the infrastructure before proceeding. Click on the "Workflow" link in the projects dashboard to access the approval stages. The output of each of the deployment runners      will also be available by clicking on the step. On the following screen, each section can be clicked on to see the output of the commands.![CircleCIWorkflow](/images/circleci4.png) ![CircleCIWorkflowOutput](/images/circleci5.png) ![CircleCIApprove](/images/circleci6.png)
9. After the pipleine successfully completes, the URL for the ALB (application load balancer) will be outputed. ![CircleCIOutput](/images/circleci7.png)
10. Enter the URL into a browser for a "Hello World" message and the internal IP address of the EC2 instance. Refreshing 
    your browser will show the ALB is load-balancing between the two instances. ![AWSALB1](/images/aws1.png) ![AWSALB2](/images/aws2.png)


<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_aws"></a> [aws](#requirement\_aws) (3.66.0)

## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws) (3.66.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [aws_autoscaling_group.demo](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/autoscaling_group) (resource)
- [aws_db_instance.default](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/db_instance) (resource)
- [aws_db_subnet_group.selected](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/db_subnet_group) (resource)
- [aws_internet_gateway.gw](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/internet_gateway) (resource)
- [aws_launch_configuration.demo](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/launch_configuration) (resource)
- [aws_lb.demo](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/lb) (resource)
- [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/lb_listener) (resource)
- [aws_lb_target_group.asg](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/lb_target_group) (resource)
- [aws_route.r](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/route) (resource)
- [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/route_table) (resource)
- [aws_route_table_association.private1](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/route_table_association) (resource)
- [aws_route_table_association.private2](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/route_table_association) (resource)
- [aws_route_table_association.public1](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/route_table_association) (resource)
- [aws_route_table_association.public2](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/route_table_association) (resource)
- [aws_security_group.alb](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/security_group) (resource)
- [aws_security_group.demo](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/security_group) (resource)
- [aws_security_group.demo_db](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/security_group) (resource)
- [aws_security_group.instance](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/security_group) (resource)
- [aws_subnet.private1](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/subnet) (resource)
- [aws_subnet.private2](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/subnet) (resource)
- [aws_subnet.public1](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/subnet) (resource)
- [aws_subnet.public2](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/subnet) (resource)
- [aws_vpc.demo](https://registry.terraform.io/providers/hashicorp/aws/3.66.0/docs/resources/vpc) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_sqlpassword"></a> [sqlpassword](#input\_sqlpassword)

Description: SQL DB admin password

Type: `string`

### <a name="input_sqlusername"></a> [sqlusername](#input\_sqlusername)

Description: SQL DB admin username

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_alb_name"></a> [alb\_name](#input\_alb\_name)

Description: The name of the ALB

Type: `string`

Default: `"terraform-asg-example"`

### <a name="input_alb_security_group_name"></a> [alb\_security\_group\_name](#input\_alb\_security\_group\_name)

Description: The name of the security group for the ALB

Type: `string`

Default: `"terraform-example-alb"`

### <a name="input_instance_security_group_name"></a> [instance\_security\_group\_name](#input\_instance\_security\_group\_name)

Description: The name of the security group for the EC2 Instances

Type: `string`

Default: `"terraform-example-instance"`

### <a name="input_server_port"></a> [server\_port](#input\_server\_port)

Description: The port the server will use for HTTP requests

Type: `number`

Default: `80`

## Outputs

The following outputs are exported:

### <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name)

Description: The domain name of the load balancer
<!-- END_TF_DOCS -->\n

Dependency graph:
![Graph](/images/ASGgraph.svg)

[comment]: # (Begin TF Docs)
# Terraform AWS Web Server with autoscaling and loadbalancer

This repository will generate 2 web servers using a launch configuration template and an autoscaling group into a cusotm VPC. Pull requests and merges to the master branch will trigger a pipeline in CircleCI that will apply the resources to AWS. To use this repository, you will need the following:

1. A [CircleCI Account](https://circleci.com/)
2. [AWS IAM User](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html) with proper permissions (policy will be included in future update)
3. Fork this repository to your github account
4. Setup the [CircleCI project](https://circleci.com/docs/2.0/project-build/)
5. After you have followed the project, click in the top right corner on the gear icon of the project (Project Settings) ![CircleCIProjectSettings](/images/circleci1.png)
6. Click "Environment Variables" and the the following 5 environment variables:
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - AWS_DEFAULT_REGION
  - sqlusername
  - sqlpassword
  ![CircleCIEnvironmentVariables](/images/circleci2.png)
7. By default, CircleCI pipeline will execute on any commit to the repository. If you do not wish for it to run on every commit, you can go to "Project Settings --> Advanced"      and toggle the "Only build on pull requests". ![CircleCIOnlyBuildPR](/images/circleci3.png)
8. This pipeline is built to have multiple stages, two of which will require a human approval to proceed to next step (Apply and Destroy). This gives a chance to review changes 
  to the infrastructure before proceeding. Click on the "Workflow" link in the projects dashboard to access the approval stages. The output of each of the deployment runners      will also be available by clicking on the step. On the following screen, each section can be clicked on to see the output of the commands.![CircleCIWorkflow](/images/circleci4.png) ![CircleCIWorkflowOutput](/images/circleci5.png) ![CircleCIApprove](/images/circleci6.png)
9. After the pipleine successfully completes, the URL for the ALB (application load balancer) will be outputed. ![CircleCIOutput](/images/circleci7.png)
10. Enter the URL into a browser for a "Hello World" message and the internal IP address of the EC2 instance. Refreshing 
    your browser will show the ALB is load-balancing between the two instances. ![AWSALB1](/images/aws1.png) ![AWSALB2](/images/aws2.png)


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