#!/bin/bash

SERVICE="app-dev-app"
TAG="latest"
echo "Updating service: app-dev-app with tag: latest"

cd /opt/application
git checkout main
git pull
git fetch origin && git reset --hard origin/main

echo "Stopping and removing app-dev-app service..."
sudo docker compose stop app-dev-app && sudo docker compose rm -f app-dev-app

echo "Removing current image if it exists..."
sudo docker rmi ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/myapp/dev-app

# Login to ECR right before pulling (important to ensure fresh token)
echo "Authenticating with AWS ECR..."
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

echo "Pulling the new image: latest..."
sudo docker pull ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/myapp/dev-app:latest

echo "Starting the app-dev-app service..."
sudo docker compose up -d app-dev-app

echo "Update completed successfully for app-dev-app using tag latest."
