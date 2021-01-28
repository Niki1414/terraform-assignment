# terraform-assignment

prerequisite for running terraform
1.To execute the terraform you need to provide below permission to the role  to that machine.

AmazonEC2FullAccess
AutoScalingFullAccess
ElasticLoadBalancingFullAccess
AmazonVPCFullAccess
2 .terraform need to be present .You can check using below command 
terraform -version

Steps to Run the script 
1. Clone full folder in your machine.
2.Terraform init
3.Terraform plan
4.Terraform apply 
5.You will get the output of load balancer dns 
6.Try accessing that url in the browser.



What resources are provisioned using this terraform .
1.It will create 1 VPC,2 Public subnets,2 Private Subnets ,Internet gateway,Nat gateway,Route table for both private and public subnets.
2.It will create launch configuration and auto scaling groups .
3.It wll create elb which has the ec2 as tagrets spin up by autoscaling group in private subnet.
4. It will create security groups .
5.It will create bastion host for connecting to private Ec2 servers.
