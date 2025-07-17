### _This guide explains how to containerize and run **Strapi** CMS_

#### Prerequisites

- Docker
- Require an existing Strapi project (Refer Day-1 to create)
- Running SQL database that you can connect with your Strapi instance (Skip for Docker compose deployment)

---

#### Containerization (Dockerfile)

- Uses Node.js 22 Alpine as the base image — a lightweight and fast image for Node apps.

- Sets an environment variable NODE_ENV=development for development mode.

- Defines environment variables for Strapi to configure SQL database:

    ```bash
    DATABASE_CLIENT
    DATABASE_HOST 
    DATABASE_PORT 
    DATABASE_NAME 
    DATABASE_USERNAME 
    DATABASE_PASSWORD
    ```

- Sets the working directory inside the container to /strapi/.

- Copies your local Strapi project files from ./strapi/test-strapi/ into the container.

- Installs project dependencies using npm install.

- Exposes port 1337, which is the default port that Strapi runs on.

- Runs the Strapi app in development mode using npm run develop. Open browser and type:  ```http://localhost:1337/admin``` to go to admin panel.

---

#### Deployment 
Two ways:
-  Docker
-  Docker compose

##### Docker

- Clone this repository:
```bash
    git clone https://github.com/KBALAJI2212/pearlthoughts-strapi.git
    cd Day-2/
```
- Copy the ```Dockerfile``` and place it in your environment where you installed strapi.

- Run the following command:
```bash
    docker build -t {strapi_image_name} {dockerfile_location}
```
```bash
    docker run -d --name container_name -e DATABASE_CLIENT= -e DATABASE_HOST= -e DATABASE_PORT=3306 -e DATABASE_NAME= -e DATABASE_USERNAME= -e DATABASE_PASSWORD= -p 1337:1337 strapi-image-name

```

Configure as needed :
```bash
    DATABASE_CLIENT: mysql          # Enter your DB host address - Default is "mysql"
    DATABASE_HOST: mysql            # Enter your DB host address - Default is "mysql"
    DATABASE_PORT: 3306
    DATABASE_NAME: strapi           #Enter Your DB Name - Default is "strapi"
    DATABASE_USERNAME: strapi       #Enter Your DB User - Default is "strapi"
    DATABASE_PASSWORD: password     #Enter Your DB Password - Default is "password"
```
- Open browser and type:  ```http://localhost:1337/admin``` to go to admin panel.

##### Docker-Compose

- Clone this repository:
```bash
    git clone https://github.com/KBALAJI2212/pearlthoughts-strapi.git
    cd Day-2/
```
- Copy the ```Dockerfile``` and ```Docker-compose.yaml```. Place it in your environment where you installed strapi.

- Run the following command:
```bash
    #At docker-compose file location
    docker compose up -d
```
Configure Docker-compose file as needed :
```bash
    #MYSQL
    environment:
        MYSQL_ROOT_PASSWORD: password  #Enter Your DB Root Password - Default is "password"
        MYSQL_DATABASE: strapi         #Enter Your DB Name - Default is "strapi"
        MYSQL_USER: strapi             #Enter Your DB User - Default is "strapi"
        MYSQL_PASSWORD: password       #Enter Your DB Password - Default is "password

    #Strapi
    environment:
        DATABASE_CLIENT: mysql          # Enter your DB host address - Default is "mysql"
        DATABASE_HOST: mysql            # Enter your DB host address - Default is "mysql"
        DATABASE_PORT: 3306
        DATABASE_NAME: strapi           #Enter Your DB Name - Default is "strapi"
        DATABASE_USERNAME: strapi       #Enter Your DB User - Default is "strapi"
        DATABASE_PASSWORD: password     #Enter Your DB Password - Default is "password"
```
- Open browser and type:  ```http://localhost:1337/admin``` to go to admin panel.

---

Video Link: [https://youtu.be/wJnG-_S2beA](https://youtu.be/wJnG-_S2beA)

PR: [https://github.com/PearlThoughts-DevOps-Internship/Strapi--Script-Smiths/pull/2](https://github.com/PearlThoughts-DevOps-Internship/Strapi--Script-Smiths/pull/2)