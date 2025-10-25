#!/bin/bash

# Docker Up Script
# This script starts Docker containers using docker-compose or docker commands

set -e

echo "=========================================="
echo "Docker Up Utility"
echo "=========================================="
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running or not installed"
    exit 1
fi

# Function to start containers with docker-compose
start_with_compose() {
    local compose_file="${1:-docker-compose.yml}"
    
    if [ ! -f "$compose_file" ]; then
        echo "Error: Compose file '$compose_file' not found"
        exit 1
    fi
    
    echo "Starting containers with $compose_file..."
    
    # Try docker compose (v2) first, fall back to docker-compose (v1)
    if command -v docker compose &> /dev/null; then
        docker compose -f "$compose_file" up -d
    elif command -v docker-compose &> /dev/null; then
        docker-compose -f "$compose_file" up -d
    else
        echo "Error: Neither 'docker compose' nor 'docker-compose' command found"
        exit 1
    fi
    
    echo "✓ Containers started successfully"
}

# Function to start all stopped containers
start_all_containers() {
    echo "Starting all stopped containers..."
    
    stopped_containers=$(docker ps -a -q -f status=exited)
    
    if [ -z "$stopped_containers" ]; then
        echo "No stopped containers found"
    else
        docker start $stopped_containers
        echo "✓ All stopped containers started"
    fi
}

# Function to start specific container
start_container() {
    local container_name="$1"
    
    if [ -z "$container_name" ]; then
        echo "Error: Container name required"
        exit 1
    fi
    
    echo "Starting container: $container_name..."
    docker start "$container_name"
    echo "✓ Container started successfully"
}

# Main logic
if [ $# -eq 0 ]; then
    # No arguments - check for docker-compose.yml
    if [ -f "docker-compose.yml" ] || [ -f "docker-compose.yaml" ]; then
        compose_file="docker-compose.yml"
        [ -f "docker-compose.yaml" ] && compose_file="docker-compose.yaml"
        start_with_compose "$compose_file"
    else
        echo "No docker-compose file found in current directory"
        echo ""
        echo "Usage:"
        echo "  $0                          - Start containers from docker-compose.yml"
        echo "  $0 -f <compose-file>        - Start containers from specified compose file"
        echo "  $0 -a, --all                - Start all stopped containers"
        echo "  $0 -c <container>, --container <container> - Start specific container"
        exit 1
    fi
elif [ "$1" == "-f" ] && [ -n "$2" ]; then
    start_with_compose "$2"
elif [ "$1" == "-a" ] || [ "$1" == "--all" ]; then
    start_all_containers
elif [ "$1" == "-c" ] || [ "$1" == "--container" ]; then
    start_container "$2"
else
    start_with_compose "$1"
fi

echo ""
echo "Current running containers:"
docker ps
