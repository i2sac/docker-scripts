#!/bin/bash

# Docker Logs Script
# View and follow logs from Docker containers

echo "=========================================="
echo "Docker Logs Viewer"
echo "=========================================="
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running or not installed"
    exit 1
fi

# Function to display help
show_help() {
    echo "Usage:"
    echo "  $0 <container-name>           - View logs for specified container"
    echo "  $0 -f <container-name>        - Follow logs in real-time"
    echo "  $0 -n <lines> <container>     - Show last N lines"
    echo "  $0 -t <time> <container>      - Show logs since timestamp (e.g., 2023-01-01T00:00:00)"
    echo "  $0 -s <since> <container>     - Show logs for duration (e.g., 10m, 1h)"
    echo ""
}

# Function to list containers
list_containers() {
    echo "Available containers:"
    echo "----------------------------------------"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"
    echo ""
}

# If no arguments provided, show help and list containers
if [ $# -eq 0 ]; then
    show_help
    list_containers
    read -p "Enter container name: " container_name
    if [ -z "$container_name" ]; then
        echo "Error: Container name required"
        exit 1
    fi
    docker logs -f "$container_name"
    exit 0
fi

# Parse arguments
follow=false
lines=""
since=""
timestamp=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -f|--follow)
            follow=true
            shift
            ;;
        -n|--lines)
            lines="$2"
            shift 2
            ;;
        -t|--timestamp)
            timestamp="$2"
            shift 2
            ;;
        -s|--since)
            since="$2"
            shift 2
            ;;
        *)
            container_name="$1"
            shift
            ;;
    esac
done

# Check if container name is provided
if [ -z "$container_name" ]; then
    echo "Error: Container name required"
    show_help
    exit 1
fi

# Build docker logs command
cmd="docker logs"

if [ "$follow" == "true" ]; then
    cmd="$cmd -f"
fi

if [ -n "$lines" ]; then
    cmd="$cmd --tail $lines"
fi

if [ -n "$timestamp" ]; then
    cmd="$cmd --since $timestamp"
fi

if [ -n "$since" ]; then
    cmd="$cmd --since $since"
fi

cmd="$cmd $container_name"

# Execute command
echo "Viewing logs for: $container_name"
if [ "$follow" == "true" ]; then
    echo "(Press Ctrl+C to exit)"
fi
echo "----------------------------------------"
$cmd
