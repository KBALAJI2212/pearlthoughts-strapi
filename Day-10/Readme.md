### _This guide explains how to automate the deployment of a Dockerized Strapi app to an AWS ECS Task using GitHub Actions and Terraform._

---

## Prerequisites

- GitHub Repository
- ECR Repository
- AWS IAM User credentials (Access Key & Secret)

---

## Setup GitHub Secrets

In your GitHub repository, go to **Settings → Secrets and variables → Actions → New repository secret**, and add:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

---

- Clone this repository:
```bash
    git clone https://github.com/KBALAJI2212/pearlthoughts-strapi.git

    cd pearlthoughts-strapi/Day-10/

```
-  Go through the ```ci.yml``` and ```terraform.yml``` and change the file to suit your repository structure.


- ```IMPORTANT```: Configure ```main.tf```, ```ecr.tf```, ```variables.tf``` file as needed.

- Now every ```push to main``` branch will start a workflow which will build, tag and push strapi image to ```ECR Repository```.

- ```Manually``` start the ```Terraform Deploy``` workflow to deploy resources in AWS.

- ```Manually``` start the ```Terraform Destroy``` workflow to destroy resources in AWS.

---

## Accessing Strapi Admin Panel

After successful deployment, you’ll see output like:

```bash

    app_lb_endpoint = http://<app_lb_dns>/admin

    #Paste this in your browser to access the admin panel.
```


---


Video Link: [https://youtu.be/c8A-w_RXRJY](https://youtu.be/c8A-w_RXRJY)

PR: [https://github.com/PearlThoughts-DevOps-Internship/Strapi--Script-Smiths/pull/2](https://github.com/PearlThoughts-DevOps-Internship/Strapi--Script-Smiths/pull/2)

---

<h2>PROJECT SCREENSHOTS</h2>

<p float="left">
  <img src="./screenshots/Screenshot From 2025-07-25 20-45-15.png" width="800"/>
  <img src="./screenshots/Screenshot From 2025-07-25 20-45-34.png" width="800"/>
  <img src="./screenshots/Screenshot From 2025-07-25 20-46-12.png" width="800"/>
  <img src="./screenshots/Screenshot From 2025-07-25 20-46-41.png" width="800"/>
  <img src="./screenshots/Screenshot From 2025-07-25 20-47-40.png" width="800"/>
  <img src="./screenshots/Screenshot From 2025-07-25 20-48-53.png" width="800"/>
  <img src="./screenshots/Screenshot From 2025-07-25 20-59-28.png" width="800"/>
</p>
