### _This guide explains how to set up a dockerized environment with the following requirements:_

- Use Docker networking to connect a Strapi container with a PostgreSQL database container.
- Configure Nginx as a reverse proxy to expose the Strapi Admin Dashboard on port 80.
- Ensure all containers run on the same user-defined Docker network.

#### Prerequisites

- Docker
- Require an existing Strapi Docker Image with Database Env Variables baked in(Refer Day-2 to create) (or) use mine ```kbalaji2212/projects:strapi```

---

#### Deployment 

Two ways:
-  Docker commands
-  Docker compose

##### Docker commands

- Copy the ```nginx/nginx.conf``` into your local environment.

- Run the following command to create docker network:
```bash
    docker network create docker-network-name
```

- Run the following command to create a volume which stores DB data:
```bash
    docker volume create postgres_data
```

- Run the following command to create a Postgres Database (replace with your values):
```bash
    docker run -d --name docker-container-name --network docker-network-name -e POSTGRES_DB= -e POSTGRES_USER= -e POSTGRES_PASSWORD= -v postgres_data:/var/lib/postgresql/data postgres:15
```

Configure as needed :
```bash
    POSTGRES_DB: strapi             #Enter Your DB Name - Default is "strapi"
    POSTGRES_USER: strapi           #Enter Your DB User - Default is "strapi"
    POSTGRES_PASSWORD: password     #Enter Your DB Password -Default is "password"
```

- Run the following command to create a Strapi container (replace with your values):
```bash
    docker run -d --name strapi --network docker-network-name -e DATABASE_CLIENT= -e DATABASE_HOST= -e DATABASE_PORT=5432 -e DATABASE_NAME= -e DATABASE_USERNAME= -e DATABASE_PASSWORD=  your-strapi-image #(or) use mine (kbalaji2212/projects:strapi)

```

Configure as needed :
```bash
      DATABASE_CLIENT: postgres       
      DATABASE_HOST: postgres         # Enter your DB host address (container name)
      DATABASE_PORT: 5432
      DATABASE_NAME: strapi           #Enter Your DB Name - Default is "strapi"
      DATABASE_USERNAME: strapi       #Enter Your DB User - Default is "strapi"
      DATABASE_PASSWORD: password     #Enter Your DB Password - Default is "password"
```

- Run the following command to create a Nginx container:
```bash
    docker run -d --name nginx --network docker-network-name -p 80:80 -v {path_of_copied_nginx_conf_file}:/etc/nginx/nginx.conf:ro nginx:alpine
```

IMPORTANT :
```bash
      #Configure the following line in your nginx.conf file.

      proxy_pass http://address:1337;  #Change address to {container name of strapi} if using docker run command (or) {service name of strapi} if using docker compose
```

- Open browser and type:  ```http://localhost:80/admin``` to go to admin panel, now available on port 80.


##### Docker compose

- Copy the ```nginx/nginx.conf``` into your local environment.
- Copy the ```docker-compose.yaml``` into your local environment.

- Run the following command to create complete setup:
```bash
    docker compose up -d
```

Configure Docker-compose file as needed :
```bash
    #Postgres
    environment:
        POSTGRES_DB: strapi             #Enter Your DB Name - Default is "strapi"
        POSTGRES_USER: strapi           #Enter Your DB User - Default is "strapi"
        POSTGRES_PASSWORD: password     #Enter Your DB Password -Default is "password"

    #Strapi
    image: your-strapi-image #or use mine (kbalaji2212/projects:strapi)
    environment:
        DATABASE_CLIENT: postgres       
        DATABASE_HOST: postgres         # Enter your DB host address (service name)
        DATABASE_PORT: 5432
        DATABASE_NAME: strapi           #Enter Your DB Name - Default is "strapi"
        DATABASE_USERNAME: strapi       #Enter Your DB User - Default is "strapi"
        DATABASE_PASSWORD: password     #Enter Your DB Password - Default is "password"
    
    #Nginx
    volumes:
      - {path_of_copied_nginx_conf_file}:/etc/nginx/nginx.conf:ro
```

IMPORTANT :
```bash
      #Configure the following line in your nginx.conf file.

      proxy_pass http://address:1337;  #Change address to {container name of strapi} if using docker run command (or) {service name of strapi} if using docker compose
```

- Open browser and type:  ```http://localhost:80/admin``` to go to admin panel, now available on port 80.

---

###### Strapi Is Not Publicly Exposed by Default

To enhance security, Strapi is not directly exposed to the internet or your local machine. This means:

-   Port 1337 (Strapi's default port) is not mapped to your host.

-   Strapi is only accessible internally (e.g., by NGINX or other services in the same Docker network).

-   You can open the port manually by inlcuding:
    ```bash
        docker run -p 1337:1337 #docker command

        ports:                  #docker compose
            - "1337:1337"  
    ```

---

Video Link: []()

PR: [https://github.com/PearlThoughts-DevOps-Internship/Strapi--Script-Smiths/pull/2](https://github.com/PearlThoughts-DevOps-Internship/Strapi--Script-Smiths/pull/2)