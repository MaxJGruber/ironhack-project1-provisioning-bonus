#!/bin/bash

echo "🚀 Installing Docker..."
sudo apt update -y
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ubuntu

echo "🌐 Creating backend Docker network..."
sudo docker network create backend_network

echo "🐳 Running PostgreSQL container..."
sudo docker pull postgres:latest
sudo docker run -d --name postgres \
  -p 5432:5432 \
  --network backend_network \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=postgres \
  postgres:latest

echo "🐳 Running Redis container..."
sudo docker pull redis:latest
sudo docker run -d --name redis \
  -p 6379:6379 \
  --network backend_network \
  redis:latest

echo "🐳 Running Worker container..."
sudo docker pull chojiu/worker-project-1:latest
sudo docker run -d --name worker \
  --network backend_network \
  -e REDIS_HOST=redis \
  -e DB_HOST=postgres \
  -e DB_USER=postgres \
  -e DB_PASSWORD=postgres \
  -e DB_NAME=postgres \
  chojiu/worker-project-1:latest

echo "✅ Backend + DB deployment complete."