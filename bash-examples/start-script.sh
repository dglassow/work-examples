#!/bin/bash

SERVICE="mw-dev-app"
TAG="latest"
echo "Updating service: mw-dev-app with tag: latest"

cd /opt/MWarfare
git checkout main
git pull
git fetch origin && git reset --hard origin/main

echo "Stopping and removing mw-dev-app service..."
sudo docker compose stop mw-dev-app && sudo docker compose rm -f mw-dev-app

echo "Removing current image if it exists..."
sudo docker rmi 929335431487.dkr.ecr.us-west-2.amazonaws.com/mwarfare/dev-app

# Login to ECR right before pulling (important to ensure fresh token)
echo "Authenticating with AWS ECR..."
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 929335431487.dkr.ecr.us-west-2.amazonaws.com

echo "Pulling the new image: latest..."
sudo docker pull 929335431487.dkr.ecr.us-west-2.amazonaws.com/mwarfare/dev-app:latest

echo "Starting the mw-dev-app service..."
sudo docker compose up -d mw-dev-app

echo "Update completed successfully for mw-dev-app using tag latest."
