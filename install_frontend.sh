#!/bin/bash

echo "🔧 Installing Docker..."
sudo apt update -y
sudo apt install -y docker.io

echo "🚀 Enabling Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

echo "👤 Adding ubuntu user to docker group..."
sudo usermod -aG docker ubuntu

echo "🐳 Pulling and running vote container..."
sudo docker pull chojiu/vote-project-1:latest
sudo docker run -d \
  --name vote \
  -p 80:80 \
  -e REDIS_HOST=10.0.3.155 \
  -e REDIS_PORT=6379 \
  chojiu/vote-project-1:latest

echo "📊 Pulling and running result container..."
sudo docker pull chojiu/result-project-1:latest
sudo docker run -d \
  --name result \
  -p 81:80 \
  -e PG_HOST=10.0.3.155 \
  -e PG_PORT=5432 \
  -e PG_USER=postgres \
  -e PG_PASSWORD=postgres \
  -e PG_NAME=postgres \
  chojiu/result-project-1:latest

echo "✅ Done. Use 'sudo docker ps' to check running containers."