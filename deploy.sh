#!/bin/bash

# Variables
IMAGE_NAME="buildnginximg"
TAG="latest"
CONTAINER_NAME="buildnginx_container"
PORT="80"  # Adjust the port as necessary

# Step 1: Pull the latest image from Docker Hub
echo "Pulling the latest Docker image: nginximg:latest"
docker pull "buildnginximg:latest"

# Step 2: Stop the currently running container (if any)
echo "Stopping the currently running container: $CONTAINER_NAME"
docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true

# Step 3: Run a new container with the latest image
echo "Running a new container: buildnginx_container"
docker run -d --name buildnginx_container -p 5000:80 buildnginximg:latest

echo "Deployment complete!"
