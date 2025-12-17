/*
This file contains the terraform code for our ECS cluster. 
This will be an ECS Fargate cluster that will run two types of containers.
One will be for the frontend of the application and the other will be for the backend.
The ECS Cluster will be spread across two availability zones for High Availability.
*/

resource "aws_ecs_cluster" "cluster" {
  name = "cluster"
}

