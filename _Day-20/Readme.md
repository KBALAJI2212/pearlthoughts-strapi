# Docker Image with Git Commit Hash and Automating Blue/Green deployments via Github Actions.

This project demonstrates how to deploy a Dockerized Strapi CMS application on AWS ECS Fargate using Blue/Green deployments via AWS CodeDeploy, managed through Terraform.

## Architecture

- **ECS Fargate**: Serverless container hosting for Strapi.
- **Application Load Balancer (ALB)**: Distributes traffic across containers.
- **AWS CodeDeploy**: Manages Blue/Green deployment strategy.
- **Amazon RDS (PostgreSQL)**: Stores Strapi content.
- **Terraform**: Infrastructure as Code for provisioning all resources.


## Prerequisites

- Terraform
- Docker image for Strapi pushed to ECR
- Existing VPC and public/private subnets
- AWS Account

## Setup GitHub Secrets

In your GitHub repository, go to **Settings → Secrets and variables → Actions → New repository secret**, and add:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`


## Deployment Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/KBALAJI2212/pearlthoughts-strapi.git

    cd pearlthoughts-strapi/_Day-20/
   ```

         -  Go through the ```Ci.yml```, ```CODE_DEPLOY.yml``` and ```TF_Deploy.yml``` and change the file to suit your repository structure and infrastructure.


         - ```IMPORTANT```: Configure ```main.tf```, ```ecs.tf```, ```variables.tf``` file as needed.


2. **Move .github/ folder to root of your repo**

         - Now every ```push to main``` branch will start a workflow which will build, tag and push strapi image to ```ECR Repository```.

         - ```Manually``` start the ```Terraform Deploy``` workflow to deploy resources in AWS.

         - ```Manually``` start the ```Blue-Green Deployment``` workflow to deploy updated ECS service and start ```Blue-Green deployment``` in AWS.

         - ```Manually``` start the ```Terraform Destroy``` workflow to destroy resources in AWS.


## AppSpec File

Your `appspec.yaml` should define container name, port, and traffic routes:
```yaml
version: 1
Resources:
  - TargetService:
      Type: AWS::ECS::Service
      Properties:
        TaskDefinition: "your-task-definiton-arn"
        LoadBalancerInfo:
          ContainerName: "your-container-name"
          ContainerPort: 1337
```

---

Video Link: [https://youtu.be/8eAFhjl5G2c](https://youtu.be/8eAFhjl5G2c)

PR: [https://github.com/PearlThoughts-DevOps-Internship/Strapi--Script-Smiths/pull/2](https://github.com/PearlThoughts-DevOps-Internship/Strapi--Script-Smiths/pull/2)

---

<h2>PROJECT SCREENSHOTS</h2>

<p float="left">
  <img src="./screenshots/Screenshot From 2025-08-04 20-03-26.png" width="800"/>
  <img src="./screenshots/Screenshot From 2025-08-04 20-04-20.png" width="800"/>
  <img src="./screenshots/Screenshot From 2025-08-04 20-02-13.png" width="800"/>
  <img src="./screenshots/Screenshot From 2025-08-04 19-15-13.png" width="800"/>
  <img src="./screenshots/Screenshot From 2025-08-04 19-24-50.png" width="800"/>
</p>
