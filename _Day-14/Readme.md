### _This guide explains how to automate the deployment of a Dockerized Strapi app to an AWS ECS Task as FARGATE SPOT launch type using Terraform._

---

## Prerequisites

- ECR Repository
- AWS IAM User credentials (Access Key & Secret)

---

## Deployment


- Clone this repository:
```bash
    git clone https://github.com/KBALAJI2212/pearlthoughts-strapi.git

    cd pearlthoughts-strapi/_Day-14/terraform

```

- ```IMPORTANT```: Configure ```main.tf```, ```ecs.tf```, ```variables.tf``` file as needed.

- Run :

```bash

   terraform init
   terraform plan
   terraform apply #if everything in plan seems right.

```

---

## Accessing Strapi Admin Panel

After successful deployment, you’ll see output like:

```bash

    app_lb_endpoint = http://<app_lb_dns>/admin

    #Paste this in your browser to access the admin panel.
```
---


Video Link: [https://youtu.be/EHIIXJ9XmJ4](https://youtu.be/EHIIXJ9XmJ4)

PR: [https://github.com/PearlThoughts-DevOps-Internship/Strapi--Script-Smiths/pull/2](https://github.com/PearlThoughts-DevOps-Internship/Strapi--Script-Smiths/pull/2)

---

<h2>PROJECT SCREENSHOTS</h2>

<p float="left">
  <img src="./screenshots/Screenshot From 2025-07-29 12-35-26.png" width="800"/>
  <img src="./screenshots/Screenshot From 2025-07-29 12-37-00.png" width="800"/>
  <img src="./screenshots/Screenshot From 2025-07-29 12-37-09.png" width="800"/>
</p>
