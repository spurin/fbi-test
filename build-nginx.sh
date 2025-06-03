#!/bin/bash

echo "🛠️ Building local Nginx reverse proxy image..."
docker build -f nginx.Dockerfile -t fbi-nginx .
