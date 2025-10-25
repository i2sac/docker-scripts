#!/bin/bash

# Docker Manager Script
# Main utility to manage Docker operations with an interactive menu

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=========================================="
echo "Docker Manager"
echo "=========================================="
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running or not installed"
    exit 1
fi

# Function to display main menu
show_main_menu() {
    echo ""
    echo "=========================================="
    echo "Docker Manager - Main Menu"
    echo "=========================================="
    echo "1)  Start containers (docker up)"
    echo "2)  Stop containers (docker down)"
    echo "3)  Reinstall containers"
    echo "4)  Cleanup Docker resources"
    echo "5)  View running containers"
    echo "6)  View all containers"
    echo "7)  View images"
    echo "8)  View volumes"
    echo "9)  View networks"
    echo "10) Container logs"
    echo "11) Container stats"
    echo "12) Execute command in container"
    echo "13) Docker system info"
    echo "14) Docker disk usage"
    echo "0)  Exit"
    echo "=========================================="
}

# Function to view running containers
view_running_containers() {
    echo ""
    echo "Running containers:"
    echo "----------------------------------------"
    docker ps
}

# Function to view all containers
view_all_containers() {
    echo ""
    echo "All containers:"
    echo "----------------------------------------"
    docker ps -a
}

# Function to view images
view_images() {
    echo ""
    echo "Docker images:"
    echo "----------------------------------------"
    docker images
}

# Function to view volumes
view_volumes() {
    echo ""
    echo "Docker volumes:"
    echo "----------------------------------------"
    docker volume ls
}

# Function to view networks
view_networks() {
    echo ""
    echo "Docker networks:"
    echo "----------------------------------------"
    docker network ls
}

# Function to view container logs
view_logs() {
    echo ""
    read -p "Enter container name or ID: " container
    if [ -z "$container" ]; then
        echo "Error: Container name required"
        return
    fi
    
    echo ""
    echo "Logs for $container (press Ctrl+C to exit):"
    echo "----------------------------------------"
    docker logs -f "$container"
}

# Function to view container stats
view_stats() {
    echo ""
    echo "Container stats (press Ctrl+C to exit):"
    echo "----------------------------------------"
    docker stats
}

# Function to execute command in container
exec_in_container() {
    echo ""
    read -p "Enter container name or ID: " container
    if [ -z "$container" ]; then
        echo "Error: Container name required"
        return
    fi
    
    read -p "Enter command (default: /bin/bash): " command
    if [ -z "$command" ]; then
        command="/bin/bash"
    fi
    
    echo ""
    echo "Executing in $container..."
    echo "----------------------------------------"
    docker exec -it "$container" $command
}

# Function to show Docker system info
show_system_info() {
    echo ""
    echo "Docker system information:"
    echo "----------------------------------------"
    docker info
}

# Function to show disk usage
show_disk_usage() {
    echo ""
    echo "Docker disk usage:"
    echo "----------------------------------------"
    docker system df -v
}

# Main interactive loop
while true; do
    show_main_menu
    read -p "Enter your choice [0-14]: " choice
    
    case $choice in
        1)
            if [ -f "$SCRIPT_DIR/docker-up.sh" ]; then
                bash "$SCRIPT_DIR/docker-up.sh"
            else
                echo "Error: docker-up.sh not found"
            fi
            ;;
        2)
            if [ -f "$SCRIPT_DIR/docker-down.sh" ]; then
                bash "$SCRIPT_DIR/docker-down.sh"
            else
                echo "Error: docker-down.sh not found"
            fi
            ;;
        3)
            if [ -f "$SCRIPT_DIR/docker-reinstall.sh" ]; then
                bash "$SCRIPT_DIR/docker-reinstall.sh"
            else
                echo "Error: docker-reinstall.sh not found"
            fi
            ;;
        4)
            if [ -f "$SCRIPT_DIR/docker-cleanup.sh" ]; then
                bash "$SCRIPT_DIR/docker-cleanup.sh"
            else
                echo "Error: docker-cleanup.sh not found"
            fi
            ;;
        5)
            view_running_containers
            ;;
        6)
            view_all_containers
            ;;
        7)
            view_images
            ;;
        8)
            view_volumes
            ;;
        9)
            view_networks
            ;;
        10)
            view_logs
            ;;
        11)
            view_stats
            ;;
        12)
            exec_in_container
            ;;
        13)
            show_system_info
            ;;
        14)
            show_disk_usage
            ;;
        0)
            echo ""
            echo "Exiting Docker Manager. Goodbye!"
            exit 0
            ;;
        *)
            echo ""
            echo "Invalid option. Please try again."
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
done
