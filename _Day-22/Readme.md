# Docker Swarm 
Docker Swarm is Docker’s native tool for container orchestration. It allows you to manage a cluster of Docker hosts (nodes), deploy services across them, scale containers, and ensure high availability.

---

## Key Features

- **Cluster Management:** Easily group multiple Docker nodes into a single Swarm cluster.
- **Scaling:** Effortlessly scale services up/down based on demand.
- **Load Balancing:** Built-in load balancing ensures traffic is evenly distributed.
- **Self-Healing:** Automatically replaces failed containers.

---

## Key Concepts

| Term     | Meaning                                                                 |
|----------|-------------------------------------------------------------------------|
| `Node`   | A server (VM or physical) running Docker.      |
| `Manager`| A node that manages the Swarm and decides where to run containers.     |
| `Worker` | A node that receives instructions and runs containers.                 |
| `Service`| A task definition for containers you want Swarm to manage.             |
| `Task`   | A single container instance of a service.                              |

---

## Deployment

### Infrastructure:

-   Either create your own number of instances and deploy docker inside them (or) copy my ```_Day-22/main.tf``` file from my [Repository](https://github.com/KBALAJI2212/pearlthoughts-strapi/tree/main/_Day-22) and use terraform to provison the resources.


### Step 1: Initialize the Swarm on the Manager Node

- Select any one instance and run the following command

    ```bash
    docker swarm init
    ```

---

### Step 2: Join Worker Nodes

- The `init` command will give you a `join` command like this:

    ```bash
    docker swarm join --token <token> <manager-ip>:2377
    ```

- To get the token again (on manager):

    ```bash
    docker swarm join-token worker
    ```

- Copy the code and paste it in all worker instances.

---

### Step 3: Deploy a Service

- Select any Leadder/Manager instance and run the following command to create a service

    ```bash
    docker service create --name <service-name> --replicas <count> <docker-image>
    ```

- Example:

    ```bash
    docker service create --name webapp --replicas 3 nginx:alpine
    ```

    - Deploys 3 instances of Nginx.
    - Automatically distributes them across available nodes.
    - Automatically heals if a container or node fails.

---

## Useful Commands

| Purpose            | Command                                                      | Description                                 |
|--------------------|--------------------------------------------------------------|---------------------------------------------|
| Init Swarm       | ```bash docker swarm init ```                                 | Make current node the Swarm manager         |
| Join Swarm       | ```bash docker swarm join --token <token> <manager-ip>:2377 ``` | Join a node to the Swarm                    |
| Get Join Token   | ```bash docker swarm join-token worker ```                    | Display the worker join command             |
| List Nodes       | ```bash docker node ls ```                                     | View all nodes in the Swarm (manager only)  |
| Promote Node     | ```bash docker node promote <node-name> ```                   | Make a worker a manager                     |
| Create Service   | ```bash docker service create --name <name> <image> ```        | Create and deploy a service                 |
| List Services    | ```bash docker service ls ```                                  | List all services in the Swarm              |
| View Tasks       | ```bash docker service ps <service-name> ```                  | View tasks (containers) of a service        |
| Scale Service    | ```bash docker service scale <name>=<replicas> ```            | Scale a service up or down                  |
| Update Service   | ```bash docker service update --image <new-image> <service> ```| Update image/version of a service           |
| Remove Service   | ```bash docker service rm <name> ```                          | Delete a service                            |
| Leave Swarm      | ```bash docker swarm leave ```                                 | Leave the swarm (for worker nodes)          |

---

## Notes

- You can **only run `docker node` commands on a Manager/Leader instance**.
- Swarm operates on port **2377 (cluster management)**, **7946 (communication)**, and **4789 (overlay network)**, so ensure security groups and firewalls allows traffic.

---

<h2>PROJECT SCREENSHOTS</h2>

### This is the Leader/Manager instance terminal output:
  <img src="./screenshots/Screenshot From 2025-08-06 16-54-29.png" width="1000"/>

### These are screenshots of worker instances terminal output:
  <img src="./screenshots/Screenshot From 2025-08-06 16-54-42.png" width="1000"/>
  <img src="./screenshots/Screenshot From 2025-08-06 16-54-51.png" width="1000"/>

### These are screenshots of NGINX homepage being served from all **3 Swarm Nodes**
  <img src="./screenshots/PT-Day22.mp4-00:04:01.333.png" width="1000"/>
  <img src="./screenshots/PT-Day22.mp4-00:04:14.817.png" width="1000"/>
  <img src="./screenshots/Screenshot From 2025-08-06 16-55-10.png" width="1000"/>
