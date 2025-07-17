### _This guide explains how to set up and run a **Strapi** CMS instance locally._

I used **Docker** to run Strapi in a container, but if you want to run it natively make sure you have the following in your local environment:

- Nodejs
- Running SQL database that you can connect with your Strapi instance
- Python (if using a SQLite database)

---
## Deployment (Docker)

- Run the following command:
    ```bash
    git clone https://github.com/KBALAJI2212/pearlthoughts-strapi.git
    cd Balaji/Day-1/
    docker compose up -d
    ```
-   Login to your container:
    ```bash
    docker exec -it strapi bash
    ```
- Run the following command:
    ```bash
    npx create-strapi@latest
    ```
-   Confirm Installing the packages.
-   Enter name of project : Example: ```Test-Strapi```
-   Now enter the following prompts:
    ```bash 
        Please log in or sign up. Select Skip 
        Do you want to use the default database (sqlite)? No 
        Choose your default database client: Select mysql 
        Database name: mysql 
        Host: mysql 
        Port: 3306 
        Username: root 
        Password: Enter your DB Password. Default is [password]
        Enable SSL connection: No 
        Start with an example structure & data? Yes 
        Start with Typescript? Yes 
        Install dependencies with npm? Yes 
        Initialize a git repository? Yes 
    ```
-   Now go into project directory : 
    ```bash
    cd Example:Test-Strapi
    ```
-   Run the following command : 
    ```bash
    npm run develop
    ```

-   Open browser and type :  ```http://localhost:1337/admin``` to go to admin panel.
---
## Deployment (Native)
- Run the following command:
    ```bash
    npx create-strapi@latest
    ```
-   Confirm Installing the packages.
-   Enter name of project : Example: ```Test-Strapi```
-   Now enter the following prompts:
    ```bash 
        Please log in or sign up. Select Skip 
        Do you want to use the default database(sqlite)? Select your SQL database
        Choose your default database client: Select your SQL database.
        Database name: Type your DB name.
        Host: Type your DB host.
        Port: Type your DB port.
        Username: Type your DB username.
        Password: Type your DB password. 
        Enable SSL connection: No 
        Start with an example structure & data? Yes 
        Start with Typescript? Yes 
        Install dependencies with npm? Yes 
        Initialize a git repository? Yes 
    ```
-   Now go into project directory : 
    ```bash
    cd Example:Test-Strapi
    ```
-   Run the following command : 
    ```bash
    npm run develop
    ```

-   Open browser and type :  ```http://localhost:1337/admin``` to go to admin panel.
---

Video Link: [https://youtu.be/3LExhnLAb9k](https://youtu.be/3LExhnLAb9k)

PR: [https://github.com/PearlThoughts-DevOps-Internship/Strapi--Script-Smiths/pull/2](https://github.com/PearlThoughts-DevOps-Internship/Strapi--Script-Smiths/pull/2)