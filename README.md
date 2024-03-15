# Server

## Part-01: Building and Containerizing Application

Requirement:
- Choose an appropriate base image from the Official Images list.
- Create a Dockerfile for the server container with the following specifications:
  - Use a volume named "servervol" and mount it at "/serverdata" in the container.
  - Install necessary packages and dependencies required for your server application.
- Write a server application in your preferred language that does the following:
  - Creates a 1KB file with random text data in the "/serverdata" directory.
  - Sends the file and its checksum to the client.
- Use Docker Compose to define and run the server container.

Execution:


## Part02: AWS-EC2 



## Part03: Monitoring Stack



## Part 04: Setting up CI/CD Pipeline | GitHub Actions

wajahat@wajahat:~/.../Dicecamp-CapstoneProject-Server$ docker ps
CONTAINER ID   IMAGE        COMMAND              CREATED          STATUS          PORTS                                       NAMES
b53b69a1a9fd   server:0.1   "python server.py"   22 minutes ago   Up 22 minutes   0.0.0.0:8000->8000/tcp, :::8000->8000/tcp   cp-server

wajahat@wajahat:~/.../Dicecamp-CapstoneProject-Server$ docker ps
CONTAINER ID   IMAGE        COMMAND              CREATED          STATUS          PORTS                                       NAMES
b53b69a1a9fd   server:0.1   "python server.py"   22 minutes ago   Up 22 minutes   0.0.0.0:8000->8000/tcp, :::8000->8000/tcp   cp-server

wajahat@wajahat:~/.../Dicecamp-CapstoneProject-Server$ docker build -t server:0.1 -f Dockerfile.server .

wajahat@wajahat:~/.../Dicecamp-CapstoneProject-Server$ docker run -d -p 8000:8000 --network app_network -e PORT:8000 -v servervol:/serverdata --name cp-server server:0.1

wajahat@wajahat:~/.../DevOps-Project-Dice-2024$ docker-compose up -d
Creating network "devops-project-dice-2024_app_network" with the default driver
Creating volume "devops-project-dice-2024_servervol" with default driver
Creating volume "devops-project-dice-2024_clientvol" with default driver
Building cp-server-02
[+] Building 40.3s (9/9) FINISHED                                                                                                               docker:default
 => [internal] load build definition from Dockerfile.server                                                                                               0.0s
 => => transferring dockerfile: 223B                                                                                                                      0.0s
 => [internal] load metadata for docker.io/library/python:3.9                                                                                             3.1s
 => [internal] load .dockerignore                                                                                                                         0.0s
 => => transferring context: 2B                                                                                                                           0.0s
 => [1/4] FROM docker.io/library/python:3.9@sha256:383d072c4b840507f25453c710969aa1e1d13e47731f294a8a8890e53f834bdf                                       0.0s
 => [internal] load build context                                                                                                                         0.1s
 => => transferring context: 303.27kB                                                                                                                     0.1s
 => CACHED [2/4] WORKDIR /app                                                                                                                             0.0s
 => [3/4] COPY . .                                                                                                                                        0.1s
 => [4/4] RUN pip install --no-cache-dir pyopenssl==20.0.1                                                                                               36.7s
 => exporting to image                                                                                                                                    0.2s 
 => => exporting layers                                                                                                                                   0.2s 
 => => writing image sha256:8b77eed8f6c2f95de4a94482c7666bc44b29bcfbd44088f0f450089feb59bae3                                                              0.0s 
 => => naming to docker.io/library/devops-project-dice-2024_cp-server-02                                                                                  0.0s

What's Next?
  1. Sign in to your Docker account → docker login
  2. View a summary of image vulnerabilities and recommendations → docker scout quickview
WARNING: Image for service cp-server-02 was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.
Building cp-client-02
[+] Building 34.9s (9/9) FINISHED                                                                                                               docker:default
 => [internal] load build definition from Dockerfile.client                                                                                               0.0s
 => => transferring dockerfile: 184B                                                                                                                      0.0s
 => [internal] load metadata for docker.io/library/python:latest                                                                                          0.0s
 => [internal] load .dockerignore                                                                                                                         0.0s
 => => transferring context: 2B                                                                                                                           0.0s
 => [1/4] FROM docker.io/library/python:latest                                                                                                            0.0s
 => [internal] load build context                                                                                                                         0.0s
 => => transferring context: 6.39kB                                                                                                                       0.0s
 => CACHED [2/4] WORKDIR /app                                                                                                                             0.0s
 => [3/4] COPY . .                                                                                                                                        0.0s
 => [4/4] RUN pip install --no-cache-dir pyopenssl==20.0.1                                                                                               34.4s
 => exporting to image                                                                                                                                    0.3s 
 => => exporting layers                                                                                                                                   0.3s 
 => => writing image sha256:ae1811fe5bf5dc9bfceb219a18c5e82b9cf096d2e49b5af0ee7a3fa1261d6579                                                              0.0s 
 => => naming to docker.io/library/devops-project-dice-2024_cp-client-02                                                                                  0.0s

What's Next?
  1. Sign in to your Docker account → docker login
  2. View a summary of image vulnerabilities and recommendations → docker scout quickview
WARNING: Image for service cp-client-02 was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.
Creating devops-project-dice-2024_cp-client-02_1 ... done
Creating devops-project-dice-2024_cp-server-02_1 ... done

docker-compose up -d 

version: '3'
services:
  server:
    build:
      context: ./Dicecamp-CapstoneProject-Server
      dockerfile: Dockerfile.server
    container_name: cp-server
    volumes:
      - servervol:/serverdata
    environment:
      - PORT=8000
    networks:
      - app_network
    ports:
      - "8000:8000"
    restart: unless-stopped
  client:
    build:
      context: ./Dicecamp-CapstoneProject-Client
      dockerfile: Dockerfile.client
    container_name: cp-client
    volumes:
      - clientvol:/clientdata
    environment:
      - PORT=8000
    networks:
      - app_network

volumes:
  servervol:
  clientvol:

networks:
  app_network:
    driver: bridge
