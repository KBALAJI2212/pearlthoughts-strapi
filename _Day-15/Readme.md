### _This guide explains how to host strapi in AWS ECS and create various content in Strapi Admin panel and access them using APIs._

---

## Prerequisites

- ECR Repository
- AWS IAM User credentials (Access Key & Secret)
- Postman or Curl

---

## Deployment


- Clone this repository:
```bash
    git clone https://github.com/KBALAJI2212/pearlthoughts-strapi.git

    cd pearlthoughts-strapi/_Day-15/terraform

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

## Creating content

### Step 1: Configure Permissions (Public Access)

     Go to Strapi Admin Panel → Settings (gear icon in left menu).

    Under "Users & Permissions Plugin", click on Roles.

    Click on the Public role.

    Scroll down and enable find and findOne for these collection types:

        Article

        Author

        Category

    Click Save.

### Step 2: Create & Publish Content

    Go to Content Manager (left sidebar).

    For each of these Collection Types:

        Article, Author, Category

    Click “Create new entry”

    Fill in the fields (e.g., for Article: title, content, author, etc.)

    Click Publish at the top-right of the page

### Step 3: Test the Public API

    Open the following URL in your terminal:

    ```bash

    curl http://<your-alb-dns>/api/<endpoint>

    ```
    If public access is enabled, you’ll get JSON data.

Video Link: [https://youtu.be/5ylHY3zhvGo](https://youtu.be/5ylHY3zhvGo)

PR: [https://github.com/PearlThoughts-DevOps-Internship/Strapi--Script-Smiths/pull/2](https://github.com/PearlThoughts-DevOps-Internship/Strapi--Script-Smiths/pull/2)

---

<h2>PROJECT SCREENSHOTS</h2>

<p float="left">
  <img src="./screenshots/Screenshot From 2025-07-30 14-23-06.png" width="800"/>
  <img src="./screenshots/Screenshot From 2025-07-30 14-51-18.png" width="800"/>
  <img src="./screenshots/Screenshot From 2025-07-30 15-08-00.png" width="800"/>
  <img src="./screenshots/Screenshot From 2025-07-30 15-08-26.png" width="800"/>
</p>
