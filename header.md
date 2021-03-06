# Terraform AWS Web Server with auto-scaling and load-balancer

Below is a high level diagram of the pipeline.
![InfraDiagram](/images/Terraform-CircleCI-AWS-ASG.svg)
 

 This repository will generate 2 web servers using a launch configuration template and an auto-scaling group into a custom VPC. Pull requests and merges to the master branch will trigger a pipeline in CircleCI that will apply the resources to AWS. To use this repository, you will need the following:

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
9. After the pipeline successfully completes, the URL for the ALB (application load balancer) will be outputed. ![CircleCIOutput](/images/circleci7.png)
10. Enter the URL into a browser for a "Hello World" message and the internal IP address of the EC2 instance. Refreshing 
     your browser will show the ALB is load-balancing between the two instances. ![AWSALB1](/images/aws1.png) ![AWSALB2](/images/aws2.png)

