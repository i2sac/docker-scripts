#!/bin/bash

# Docker Down Script
# This script stops Docker containers using docker-compose or docker commands

set -e

echo "=========================================="
echo "Docker Down Utility"
echo "=========================================="
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running or not installed"
    exit 1
fi

# Function to stop containers with docker-compose
stop_with_compose() {
    local compose_file="${1:-docker-compose.yml}"
    local remove_volumes="${2:-false}"
    
    if [ ! -f "$compose_file" ]; then
        echo "Error: Compose file '$compose_file' not found"
        exit 1
    fi
    
    echo "Stopping containers with $compose_file..."
    
    # Try docker compose (v2) first, fall back to docker-compose (v1)
    if command -v docker compose &> /dev/null; then
        if [ "$remove_volumes" == "true" ]; then
            docker compose -f "$compose_file" down -v
        else
            docker compose -f "$compose_file" down
        fi
    elif command -v docker-compose &> /dev/null; then
        if [ "$remove_volumes" == "true" ]; then
            docker-compose -f "$compose_file" down -v
        else
            docker-compose -f "$compose_file" down
        fi
    else
        echo "Error: Neither 'docker compose' nor 'docker-compose' command found"
        exit 1
    fi
    
    echo "✓ Containers stopped successfully"
}

# Function to stop all running containers
stop_all_containers() {
    echo "Stopping all running containers..."
    
    running_containers=$(docker ps -q)
    
    if [ -z "$running_containers" ]; then
        echo "No running containers found"
    else
        docker stop $running_containers
        echo "✓ All running containers stopped"
    fi
}

# Function to stop specific container
stop_container() {
    local container_name="$1"
    
    if [ -z "$container_name" ]; then
        echo "Error: Container name required"
        exit 1
    fi
    
    echo "Stopping container: $container_name..."
    docker stop "$container_name"
    echo "✓ Container stopped successfully"
}

# Main logic
remove_volumes=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -f)
            compose_file="$2"
            shift 2
            ;;
        -v|--volumes)
            remove_volumes=true
            shift
            ;;
        -a|--all)
            stop_all_containers
            echo ""
            echo "Current running containers:"
            docker ps
            exit 0
            ;;
        -c|--container)
            stop_container "$2"
            echo ""
            echo "Current running containers:"
            docker ps
            exit 0
            ;;
        *)
            if [ -f "$1" ]; then
                compose_file="$1"
                shift
            else
                echo "Unknown option or file not found: $1"
                echo ""
                echo "Usage:"
                echo "  $0                          - Stop containers from docker-compose.yml"
                echo "  $0 -f <compose-file>        - Stop containers from specified compose file"
                echo "  $0 -v, --volumes            - Stop containers and remove volumes"
                echo "  $0 -a, --all                - Stop all running containers"
                echo "  $0 -c <container>, --container <container> - Stop specific container"
                exit 1
            fi
            ;;
    esac
done

# If no specific action was taken, use compose file
if [ -z "$compose_file" ]; then
    if [ -f "docker-compose.yml" ]; then
        compose_file="docker-compose.yml"
    elif [ -f "docker-compose.yaml" ]; then
        compose_file="docker-compose.yaml"
    else
        echo "No docker-compose file found in current directory"
        echo ""
        echo "Usage:"
        echo "  $0                          - Stop containers from docker-compose.yml"
        echo "  $0 -f <compose-file>        - Stop containers from specified compose file"
        echo "  $0 -v, --volumes            - Stop containers and remove volumes"
        echo "  $0 -a, --all                - Stop all running containers"
        echo "  $0 -c <container>, --container <container> - Stop specific container"
        exit 1
    fi
fi

stop_with_compose "$compose_file" "$remove_volumes"

echo ""
echo "Current running containers:"
docker ps
