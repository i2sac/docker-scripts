#!/bin/bash

# Docker Info Script
# Display detailed information about Docker containers, images, volumes, and networks

echo "=========================================="
echo "Docker System Information"
echo "=========================================="
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running or not installed"
    exit 1
fi

# Display Docker version
echo "Docker Version:"
echo "----------------------------------------"
docker version
echo ""

# Display running containers
echo "Running Containers:"
echo "----------------------------------------"
running_count=$(docker ps -q | wc -l)
if [ $running_count -eq 0 ]; then
    echo "No running containers"
else
    docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"
fi
echo ""

# Display all containers
echo "All Containers:"
echo "----------------------------------------"
total_count=$(docker ps -a -q | wc -l)
if [ $total_count -eq 0 ]; then
    echo "No containers found"
else
    docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Size}}"
fi
echo ""

# Display images
echo "Docker Images:"
echo "----------------------------------------"
image_count=$(docker images -q | wc -l)
if [ $image_count -eq 0 ]; then
    echo "No images found"
else
    docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}"
fi
echo ""

# Display volumes
echo "Docker Volumes:"
echo "----------------------------------------"
volume_count=$(docker volume ls -q | wc -l)
if [ $volume_count -eq 0 ]; then
    echo "No volumes found"
else
    docker volume ls
fi
echo ""

# Display networks
echo "Docker Networks:"
echo "----------------------------------------"
docker network ls
echo ""

# Display disk usage
echo "Docker Disk Usage:"
echo "----------------------------------------"
docker system df
echo ""

# Display system info summary
echo "System Summary:"
echo "----------------------------------------"
echo "Running Containers: $running_count"
echo "Total Containers: $total_count"
echo "Images: $image_count"
echo "Volumes: $volume_count"
