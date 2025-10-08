# docker-scripts

A collection of useful bash scripts to manage Docker containers, images, volumes, and networks. These scripts provide convenient commands for common Docker operations.

## Features

- **docker-cleanup.sh** - Clean up unused Docker resources (containers, images, volumes, networks)
- **docker-up.sh** - Start Docker containers using docker-compose or docker commands
- **docker-down.sh** - Stop Docker containers gracefully
- **docker-reinstall.sh** - Reinstall containers (stop, remove, and restart)
- **docker-manager.sh** - Interactive menu-driven interface for all Docker operations
- **docker-info.sh** - Display comprehensive Docker system information
- **docker-logs.sh** - View and follow container logs with various filtering options

## Installation

1. Clone this repository:
```bash
git clone https://github.com/i2sac/docker-scripts.git
cd docker-scripts
```

2. Make scripts executable (already done):
```bash
chmod +x *.sh
```

3. Optionally, add to your PATH:
```bash
# Add to ~/.bashrc or ~/.zshrc
export PATH="$PATH:/path/to/docker-scripts"
```

## Usage

### Docker Manager (Interactive Menu)

Run the main menu-driven interface:
```bash
./docker-manager.sh
```

This provides an interactive menu with all available operations.

### Docker Cleanup

Clean up unused Docker resources:

```bash
# Interactive mode
./docker-cleanup.sh

# Non-interactive mode
./docker-cleanup.sh containers    # Remove stopped containers
./docker-cleanup.sh images        # Remove unused images
./docker-cleanup.sh volumes       # Remove unused volumes
./docker-cleanup.sh networks      # Remove unused networks
./docker-cleanup.sh all           # Full cleanup
./docker-cleanup.sh system        # Docker system prune
```

### Docker Up

Start Docker containers:

```bash
# Start from docker-compose.yml in current directory
./docker-up.sh

# Start from specific compose file
./docker-up.sh -f docker-compose.prod.yml

# Start all stopped containers
./docker-up.sh -a

# Start specific container
./docker-up.sh -c container_name
```

### Docker Down

Stop Docker containers:

```bash
# Stop from docker-compose.yml in current directory
./docker-down.sh

# Stop from specific compose file
./docker-down.sh -f docker-compose.prod.yml

# Stop and remove volumes
./docker-down.sh -v

# Stop all running containers
./docker-down.sh -a

# Stop specific container
./docker-down.sh -c container_name
```

### Docker Reinstall

Reinstall containers (useful for updates):

```bash
# Reinstall from docker-compose.yml
./docker-reinstall.sh

# Reinstall from specific compose file
./docker-reinstall.sh -f docker-compose.prod.yml

# Reinstall with rebuild (no cache)
./docker-reinstall.sh -b

# Reinstall specific container
./docker-reinstall.sh -c container_name
```

### Docker Info

Display comprehensive Docker system information:

```bash
./docker-info.sh
```

Shows:
- Docker version
- Running and stopped containers
- Images
- Volumes
- Networks
- Disk usage
- System summary

### Docker Logs

View container logs:

```bash
# Interactive mode
./docker-logs.sh

# View logs for specific container
./docker-logs.sh container_name

# Follow logs in real-time
./docker-logs.sh -f container_name

# Show last 100 lines
./docker-logs.sh -n 100 container_name

# Show logs since timestamp
./docker-logs.sh -t 2023-01-01T00:00:00 container_name

# Show logs for last 10 minutes
./docker-logs.sh -s 10m container_name
```

## Requirements

- Docker installed and running
- Bash shell
- docker-compose (optional, for compose-related operations)

## Common Use Cases

### Daily Cleanup
```bash
./docker-cleanup.sh all
```

### Update and Restart Services
```bash
./docker-reinstall.sh -b
```

### Check System Status
```bash
./docker-info.sh
```

### Debug Container Issues
```bash
./docker-logs.sh -f problematic_container
```

### Quick Start/Stop
```bash
./docker-up.sh    # Start services
./docker-down.sh  # Stop services
```

## Tips

- Run `./docker-manager.sh` for a user-friendly interactive interface
- Use `-h` or `--help` flag on any script for detailed usage information
- Scripts check if Docker is running and provide helpful error messages
- All scripts support both interactive and non-interactive modes
- Scripts work with both docker-compose v1 and v2

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Author

i2sac

## Support

For issues, questions, or suggestions, please open an issue on GitHub.