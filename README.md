# Production-Grade 3-Tier AWS Architecture

## Overview
A highly available, secure, and containerized web application environment deployed on AWS using ECS Fargate and Terraform. 

## Note
To maintain cost-efficiency and adhere to FinOps best practices, the live environment for this project is currently de-provisioned


## Architecture Diagram
<img width="1164" height="1126" alt="architecture_diagram_v1" src="https://github.com/user-attachments/assets/0eb34060-d2c0-4640-a3ae-4d8e3d225fec" />

## Architectural Decision Matrix

|Feature|Decision|Justification
|---|---|---|
|Compute: Fargate vs EC2|Fargate|I chose AWS Fargate over EC2 to minimize operational overhead. By moving to a serverless container model, I eliminated the need for manual managing, patching, and scaling of underlying EC2 instances, allowing me to focus entirely on application architecture. From a cost perspective, Fargate’s pay as you go model is ideal for the unpredictable traffic patterns of a new application. EC2 offers lower baseline costs which are further magnified when Reserved Instances and Savings Plans are implemented, but those require predictable traffic to be effective. I decided moving to EC2 is a good candidate for a Day 2 optimization. Once traffic patterns stabilize, I can evaluate if the cost savings of Reserved EC2 instances outweigh the increased maintenance burden.|
|Availability: Multi-AZ vs Single-AZ|Multi-AZ|I decided to use a multi-AZ architecture for my project because I wanted to design a system that was Highly Available, and to do that I had to address my single points of failure. By using a multi-AZ setup, I have implemented redundancy and addressed these points. By distributing the Application Load Balancer and ECS Fargate tasks across two Availability Zones, the system can automatically reroute traffic and maintain service even during a full data center outage. Additionally, I have my RDS DB set up in a multi-AZ config, rather than a single instance. This provides synchronous replication of data from the primary "write" DB to the secondary, so data is always in sync, along with automatic failover in the case the primary instance goes down. While this architecture does come with added costs, it is a critical part of maintaining high availability.|
|Networking: Subnetting|Placed ECS and RDS in Private Subnets|I implemented a Defense in Depth strategy by placing my ECS tasks and RDS DB in private subnets and denying public IP access to these resources. This ensures the compute and data resources are isolated from the public internet and will only accept traffic routed through the ALB.|
|Security: Security Group Policies|Security Group Chaining|I utilized Security Group Chaining to enforce the Principle of Least Privilege. The ECS tasks accept traffic on ports 8080 and 3000 from the ALB's security group, and the RDS only accepts traffic on port 5432 from the ECS security group.|
|Logging: S3 vs CloudWatch|Hybrid Solution|I implemented a tiered observability strategy to balance real-time operational visibility with long-term cost efficiency. I routed logs with high realtime value, such as ECS application logs and RDS system logs, to CloudWatch. This ensures that during a production incident, there is immediate access to the real-time streams and metric filters needed for response. For high volume analysis and compliance data, such as VPC Flow Logs, ALB Access Logs, and WAF logs, I stored logs directly to S3. By taking advantage of S3’s low cost storage and Lifecycle Policies, I avoided the significant ingestion and storage costs associated with CloudWatch. This data remains accessible for analysis and long term auditing with Athena, providing a 'Serverless Data Lake' approach that scales indefinitely while remaining low cost.|
|Infrastructure as Code: Terraform vs Console|Terraform|I chose to use Terraform to build my project as opposed to building it in the console. IaC such as Terraform is the industry standard for building and maintaining cloud infrastructure. Using Terraform allowed me to design an architecture that could be built, destroyed, and redeployed in an identical manner within minutes. It also allows for peer review and version control on GitHub and allows for work to be done by multiple people concurrently. While it may have been quicker to use the console for a one-time-build, I wanted to make sure I had an architecture that met the standards used every day in business.|
|Secrets: Secrets Manager vs Environmental Variables|Secrets Manager|I chose to use Secrets Manager with RDS to avoid hardcoding sensitive credentials in Terraform or Task Definitions. Secrets Manager allows for automatic secret rotation and ensures that even if the source code is compromised, the production database remain secure.|
|Internet Access: NAT Gateway vs VPC Endpoints|NAT Gateway|I chose to implement my design with NAT Gateways rather than VPC Endpoints. Creating NAT Gateways in my public subnets was the most efficient way to provide my ECS tasks, hosted in the private subnets of each AZ, with public internet access. The cluster needs access to ECR and S3, and it also needs internet access to perform updates and patching. Using NAT Gateways over VPC Endpoints provided me with reduced time to go to production, which was valuable in this case. A Day 2 optimization I'm planning to implement is setting up a VPC Endpoint for ECR access and an S3 Gateway endpoint for the cluster to access S3. This will provide added security, due to the PrivateLink connection, and reduced costs, due to reduced traffic through each NAT Gateway.|


## Future Roadmap (Day 2)
- Create a CI/CD Pipeline using GitHub Actions to automate deployments
- VPC Endpoints to provide increased security and reduced costs for data retreived from S3 and ECR.
- EventBridge Integration to add an element of Event Driven Architecture.
- Refactor the VPC to include an isolated Private Subnet for RDS to provide another layer of security.
- Utilize Athena and Quicksight to create detailed dashboards.
- Second iteration of RDS Logs and look to make improvements.

## Deployment
1. AWS CLI configured with appropriate permissions
2. Terraform installed
3. Docker Installed

Create Remote Backend

4. Navigate to terraform/backend folder
5. `terraform init`
6. `terraform plan`
7. `terraform apply -auto-approve`

Create ECR Repositories

8. Navigate to terraform/ecr folder
9. `terraform init`
10. `terraform plan`
11. `terraform apply -auto-approve`

12. Push Dockerfile images to ECR; Cloned and updated from https://github.com/docker/getting-started-todo-app

Build Architecture

13. Navigate to terraform/environments/dev
14. `terraform init`
15. `terraform plan`
16. `terraform apply -auto-approve`

# Author
Evan Mercurio - AWS Certified Solutions Architect, AWS Certified AI Practitioner, & Full-Stack Engineer
linkedin.com/in/evan-mercurio-503707191
