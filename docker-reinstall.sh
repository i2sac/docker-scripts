#!/bin/bash

# Docker Reinstall Script
# This script stops, removes, and restarts Docker containers

set -e

echo "=========================================="
echo "Docker Reinstall Utility"
echo "=========================================="
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running or not installed"
    exit 1
fi

# Function to reinstall containers with docker-compose
reinstall_with_compose() {
    local compose_file="${1:-docker-compose.yml}"
    local rebuild="${2:-false}"
    
    if [ ! -f "$compose_file" ]; then
        echo "Error: Compose file '$compose_file' not found"
        exit 1
    fi
    
    echo "Reinstalling containers with $compose_file..."
    echo ""
    
    # Try docker compose (v2) first, fall back to docker-compose (v1)
    local compose_cmd=""
    if command -v docker compose &> /dev/null; then
        compose_cmd="docker compose"
    elif command -v docker-compose &> /dev/null; then
        compose_cmd="docker-compose"
    else
        echo "Error: Neither 'docker compose' nor 'docker-compose' command found"
        exit 1
    fi
    
    # Stop and remove containers
    echo "Step 1: Stopping containers..."
    $compose_cmd -f "$compose_file" down -v
    echo "✓ Containers stopped and removed"
    echo ""
    
    # Optionally rebuild images
    if [ "$rebuild" == "true" ]; then
        echo "Step 2: Rebuilding images..."
        $compose_cmd -f "$compose_file" build --no-cache
        echo "✓ Images rebuilt"
        echo ""
        echo "Step 3: Starting containers..."
    else
        echo "Step 2: Starting containers..."
    fi
    
    # Start containers
    $compose_cmd -f "$compose_file" up -d
    echo "✓ Containers started successfully"
}

# Function to reinstall specific container
reinstall_container() {
    local container_name="$1"
    
    if [ -z "$container_name" ]; then
        echo "Error: Container name required"
        exit 1
    fi
    
    echo "Reinstalling container: $container_name..."
    echo ""
    
    # Get the image name before removing
    local image_name=$(docker inspect --format='{{.Config.Image}}' "$container_name" 2>/dev/null || echo "")
    
    if [ -z "$image_name" ]; then
        echo "Error: Container '$container_name' not found"
        exit 1
    fi
    
    # Stop and remove container
    echo "Step 1: Stopping and removing container..."
    docker stop "$container_name" 2>/dev/null || true
    docker rm "$container_name" 2>/dev/null || true
    echo "✓ Container removed"
    echo ""
    
    echo "Step 2: Pulling latest image..."
    docker pull "$image_name"
    echo "✓ Image updated"
    echo ""
    
    echo "To start the container, use: docker run [options] $image_name"
    echo "Or use docker-compose if this container is part of a compose setup"
}

# Main logic
rebuild=false
compose_file=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -f)
            compose_file="$2"
            shift 2
            ;;
        -b|--build|--rebuild)
            rebuild=true
            shift
            ;;
        -c|--container)
            reinstall_container "$2"
            echo ""
            echo "Current running containers:"
            docker ps
            exit 0
            ;;
        -h|--help)
            echo "Usage:"
            echo "  $0                          - Reinstall containers from docker-compose.yml"
            echo "  $0 -f <compose-file>        - Reinstall containers from specified compose file"
            echo "  $0 -b, --build              - Rebuild images before starting"
            echo "  $0 -c <container>, --container <container> - Reinstall specific container"
            exit 0
            ;;
        *)
            if [ -f "$1" ]; then
                compose_file="$1"
                shift
            else
                echo "Unknown option or file not found: $1"
                echo "Use -h or --help for usage information"
                exit 1
            fi
            ;;
    esac
done

# If no compose file specified, look for default
if [ -z "$compose_file" ]; then
    if [ -f "docker-compose.yml" ]; then
        compose_file="docker-compose.yml"
    elif [ -f "docker-compose.yaml" ]; then
        compose_file="docker-compose.yaml"
    else
        echo "No docker-compose file found in current directory"
        echo ""
        echo "Usage:"
        echo "  $0                          - Reinstall containers from docker-compose.yml"
        echo "  $0 -f <compose-file>        - Reinstall containers from specified compose file"
        echo "  $0 -b, --build              - Rebuild images before starting"
        echo "  $0 -c <container>, --container <container> - Reinstall specific container"
        exit 1
    fi
fi

reinstall_with_compose "$compose_file" "$rebuild"

echo ""
echo "Current running containers:"
docker ps
