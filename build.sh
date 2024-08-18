#!/bin/bash

# Variables
IMAGE_NAME="buildnginximg"
TAG="latest"

# Step 1: Build the Docker image
echo "Building Docker image: buildnginximg:latest"
docker build -t buildnginximg:latest .

# Step 2: Optionally tag the image with another tag
# Uncomment the line below if you want to tag the image with another version
# docker tag $IMAGE_NAME:$TAG $IMAGE_NAME:your-tag

# Step 3: Optional cleanup
# Uncomment the line below to remove the local image after pushing
# docker rmi $nginximg:latest$

echo "Docker image build"
