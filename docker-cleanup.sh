#!/bin/bash

# Docker Cleanup Script
# This script removes unused Docker containers, images, volumes, and networks

set -e

echo "=========================================="
echo "Docker Cleanup Utility"
echo "=========================================="
echo ""

# Function to display cleanup options
show_menu() {
    echo "Select cleanup option:"
    echo "1) Remove all stopped containers"
    echo "2) Remove all unused images"
    echo "3) Remove all unused volumes"
    echo "4) Remove all unused networks"
    echo "5) Full cleanup (all of the above)"
    echo "6) Prune system (Docker's built-in cleanup)"
    echo "7) Exit"
    echo ""
}

# Function to remove stopped containers
cleanup_containers() {
    echo "Removing stopped containers..."
    docker container prune -f
    echo "✓ Stopped containers removed"
}

# Function to remove unused images
cleanup_images() {
    echo "Removing unused images..."
    docker image prune -a -f
    echo "✓ Unused images removed"
}

# Function to remove unused volumes
cleanup_volumes() {
    echo "Removing unused volumes..."
    docker volume prune -f
    echo "✓ Unused volumes removed"
}

# Function to remove unused networks
cleanup_networks() {
    echo "Removing unused networks..."
    docker network prune -f
    echo "✓ Unused networks removed"
}

# Function to perform full cleanup
full_cleanup() {
    echo "Performing full cleanup..."
    cleanup_containers
    cleanup_images
    cleanup_volumes
    cleanup_networks
    echo "✓ Full cleanup completed"
}

# Function to run Docker system prune
system_prune() {
    echo "Running Docker system prune..."
    docker system prune -a -f --volumes
    echo "✓ System prune completed"
}

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running or not installed"
    exit 1
fi

# If arguments are provided, run non-interactively
if [ $# -gt 0 ]; then
    case "$1" in
        containers|1)
            cleanup_containers
            ;;
        images|2)
            cleanup_images
            ;;
        volumes|3)
            cleanup_volumes
            ;;
        networks|4)
            cleanup_networks
            ;;
        all|full|5)
            full_cleanup
            ;;
        system|prune|6)
            system_prune
            ;;
        *)
            echo "Invalid option: $1"
            echo "Usage: $0 [containers|images|volumes|networks|all|system]"
            exit 1
            ;;
    esac
else
    # Interactive mode
    while true; do
        show_menu
        read -p "Enter your choice [1-7]: " choice
        echo ""
        
        case $choice in
            1)
                cleanup_containers
                ;;
            2)
                cleanup_images
                ;;
            3)
                cleanup_volumes
                ;;
            4)
                cleanup_networks
                ;;
            5)
                full_cleanup
                ;;
            6)
                system_prune
                ;;
            7)
                echo "Exiting..."
                exit 0
                ;;
            *)
                echo "Invalid option. Please try again."
                ;;
        esac
        echo ""
    done
fi
