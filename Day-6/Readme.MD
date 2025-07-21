### _This guide explains how to deploy a dockerized Strapi environment in AWS EC2 instance using Terraform and Bash Script :_

#### Prerequisites

- Terraform
- AWS Account
- Require an existing Strapi Docker Image with Database Env Variables baked in (Refer Day-2 to create) (or) use mine ```kbalaji2212/projects:strapi```

---

#### Deployment 

- Clone this repository:
```bash
    git clone https://github.com/KBALAJI2212/pearlthoughts-strapi.git

    cd pearlthoughts-strapi/Day-6/

```
- ```OPTIONAL:``` You can copy the ```strapi-deployment.sh``` into your own Git Repo and reference it inside ```user_data``` of ```main.tf``` file.

- To use your AWS IAM credentials to authenticate the Terraform AWS provider, set the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables.

```bash
    $ export AWS_ACCESS_KEY_ID=         #Enter your AWS ACCESS KEY ID
    $ export AWS_SECRET_ACCESS_KEY=     #Enter your AWS ACCESS KEY SECRET
```

- Run the following command to initialize Terraform:
```bash
    terraform init
```

- Run the following command to see the AWS resources to be created by Terraform:
```bash
    terraform apply  #If everything seems right proceed by typing "yes".
```

- In the terminal running terraform, you  will see a similar following output. Paste the output in browser to access Strapi Admin Panel. ```NOTE:Takes time to deploy - please wait patiently :)```
```bash
    Strapi_address= http://a.b.c.d:1337/admin 
```

- ```IMPORTANT```: Configure ```main.tf``` file as needed :
```bash
  ami                         = "ami-0eb9d6fc9fab44d24"    #Amazon Linux 2023 AMI for us-east-2. Change if needed.
  instance_type               = "t3.small"                 #Change if needed
  vpc_security_group_ids      = ["sg-038861db81239cf2a"]   #Change this value to your SG ID.
  subnet_id                   = "subnet-0cc813dd4d76bf797" #Change this value to your Subnet ID.
  key_name                    = "strapi_key_balaji"        #Replace with your own keypair to have SSH access

```
- ```OPTIONAL```: Configure ```strapi-deployment.sh``` file as needed :
```bash
    #PostgresDB
    POSTGRES_DB: strapi             #Enter Your DB Name - Default is "strapi"
    POSTGRES_USER: strapi           #Enter Your DB User - Default is "strapi"
    POSTGRES_PASSWORD: password     #Enter Your DB Password -Default is "password"

    #Strapi
    image: your-strapi-image #or use mine (kbalaji2212/projects:strapi)
    DATABASE_CLIENT: postgres       
    DATABASE_HOST: postgres         # Enter your DB host address (container name)
    DATABASE_PORT: 5432
    DATABASE_NAME: strapi           #Enter Your DB Name - Default is "strapi"
    DATABASE_USERNAME: strapi       #Enter Your DB User - Default is "strapi"
    DATABASE_PASSWORD: password     #Enter Your DB Password - Default is "password"
```
---

Video Link: []()

PR: [https://github.com/PearlThoughts-DevOps-Internship/Strapi--Script-Smiths/pull/2](https://github.com/PearlThoughts-DevOps-Internship/Strapi--Script-Smiths/pull/2)