# Flaskapp in container
### Description  
The application is written in Python language with Flask framework support, and it has been designed to store data

# Task description
Prepare docker image and docker-compose which purpose is to deploy a simple web application along with Redis data structure store server. 

## Prerequisites
Make sure you have already installed both Docker Engine and Docker Compose. You don’t need to install Python or Redis, as both are provided by Docker images.

## Dockerfile
The image contains all the dependencies the Python application requires, including Python itself.
```
#pull official base image
FROM python:3.7-alpine

#set work directory
RUN mkdir /app
WORKDIR /app
COPY ./flask /app

#install dependencies
RUN python3 -m pip install -r requirements.txt
EXPOSE 8000
CMD ["gunicorn", "-w 4", "-b", "0.0.0.0:8000", "main:app"]
```

This tells Docker to:
- Build an image starting with the Python 3.7-alpine image.
- Set the working directory to /app.
- Copy everything that is inside /flask directory, including requirements.txt, and install the Python dependencies.
- Add metadata to the image to describe that the container is listening on port 8000
- Set the default command for the container to flask run.


## Compose file
This Compose file defines two services: **app** and **redis**.
```
version: "3"

services:
  app:
    image: my-app
    build: flask
    container_name: flask
    restart: always
    ports:
      - 81:8000
    depends_on:
      - redis
    environment:
      - REDIS_PORT=6379
      - REDIS_HOSTNAME=redis
  redis:
    image: "redis:alpine"
    container_name: redis
    restart: always
    ports:
      - 6379:6379
    volumes:
      - app:/data
volumes:
  app:
```
#App service
The web service uses an image that’s built from the Dockerfile in the current directory. It then binds the container and the host machine to the exposed port, 81. This service uses the default port for the Flask web server, 8000.

#Redis service
The redis service uses a public Redis image pulled from the Docker Hub registry.

## Build and run app with Compose
1. From your project directory, start up your application by running
```
docker compose up
```
Compose pulls a Redis image, builds an image for your code, and starts the services you defined. In this case, the code is statically copied into the image at build time..

2. Enter http://localhost:8000/ in a browser to see the application running. If this doesn’t resolve, you can also try http://127.0.0.1:8000.
You should see a message in your browser  with counted visit and following text:
```
Welcome to the page! 
```
3. Refresh the page. The number should increment.

## Authors
* **Blazej Hinc**

## Acknowledgments
* Hat tip to anyone whose code was used
