### _This guide explains how to deploy of a Strapi app as an AWS ECS Task using Terraform._

---

## Prerequisites

- DockerHub Repository
- AWS IAM User credentials (Access Key & Secret)

---

## Deployment


- Clone this repository:
```bash
    git clone https://github.com/KBALAJI2212/pearlthoughts-strapi.git

    cd pearlthoughts-strapi/Day-9/

```

- ```IMPORTANT```: Configure ```main.tf```, ```ecr.tf```, ```variables.tf``` file as needed.

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

Video Link: [https://youtu.be/R9KlzVIzkuY](https://youtu.be/R9KlzVIzkuY)

PR: [https://github.com/PearlThoughts-DevOps-Internship/Strapi--Script-Smiths/pull/2](https://github.com/PearlThoughts-DevOps-Internship/Strapi--Script-Smiths/pull/2)

---

<h2>PROJECT SCREENSHOTS</h2>

<p float="left">
  <img src="./screenshots/Screenshot From 2025-07-24 20-21-39.png" width="1000"/>
  <img src="./screenshots/Screenshot From 2025-07-24 20-23-58.png" width="1000"/>
  <img src="./screenshots/Screenshot From 2025-07-24 20-24-37.png" width="1000"/>
  <img src="./screenshots/Screenshot From 2025-07-24 20-25-14.png" width="1000"/>
</p>
