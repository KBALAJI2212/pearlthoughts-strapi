### _This guide explains how to automate the deployment of a Dockerized Strapi app to an AWS EC2 instance using GitHub Actions and Terraform._

---

## Prerequisites

- GitHub Repository
- DockerHub Repository
- AWS IAM User credentials (Access Key & Secret)

---

## Setup GitHub Secrets

In your GitHub repository, go to **Settings → Secrets and variables → Actions → New repository secret**, and add:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `DOCKER_HUB_USERNAME`
- `DOCKER_HUB_TOKEN`

---

- Clone this repository:
```bash
    git clone https://github.com/KBALAJI2212/pearlthoughts-strapi.git

    cd pearlthoughts-strapi/Day-7/

```
-  Go through the ```ci.yml``` and ```terraform.yml``` and change the file to suit your repository structure.


- ```IMPORTANT```: Configure ```main.tf``` file as needed :
```bash
  ami                         = "ami-0eb9d6fc9fab44d24"    #Amazon Linux 2023 AMI for us-east-2. Change if needed.
  instance_type               = "t3.small"                 #Change if needed
  key_name                    = "strapi_key_balaji"        #Replace with your own keypair to have SSH access

```

---

## Accessing Strapi Admin Panel

After successful deployment, you’ll see output like:

```bash
    Strapi_address = http://<public-ip>:1337/admin

    #Paste this in your browser to access the admin panel.
```


---


Video Link: [https://youtu.be/Y91pcxOUvJ8](https://youtu.be/Y91pcxOUvJ8)

PR: [https://github.com/PearlThoughts-DevOps-Internship/Strapi--Script-Smiths/pull/2](https://github.com/PearlThoughts-DevOps-Internship/Strapi--Script-Smiths/pull/2)

---

<h2>PROJECT SCREENSHOTS</h2>

<p float="left">
  <img src="./screenshots/Screenshot From 2025-07-22 19-40-22.png" width="500"/>
  <img src="./screenshots/Screenshot From 2025-07-22 19-40-48.png" width="500"/>
  <img src="./screenshots/Screenshot From 2025-07-22 19-41-09.png" width="500"/>
  <img src="./screenshots/Screenshot From 2025-07-22 19-41-33.png" width="500"/>
  <img src="./screenshots/Screenshot From 2025-07-22 19-42-06.png" width="500"/>
</p>
