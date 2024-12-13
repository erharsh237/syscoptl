#!/bin/bash

VERSION="v0.1.0"

# Help function
function show_help {
    cat <<EOF
Usage: sysopctl <command> [options]

Commands:
  service list            List all running services.
  service start <name>    Start a specified service.
  service stop <name>     Stop a specified service.
  system load             View the system load averages.
  disk usage              Show disk usage statistics.
  process monitor         Monitor real-time system processes.
  logs analyze            Analyze and display critical logs.
  backup <path>           Backup system files from a specified path.

Options:
  --help                  Show this help message.
  --version               Show version information.

Example:
  sysopctl service list
  sysopctl system load
EOF
}

# Version function
function show_version {
    echo "sysopctl version $VERSION"
}

# List all active services
function list_services {
    systemctl list-units --type=service --state=active --no-pager
}

# Show system load averages
function show_load {
    uptime
}

# Start a system service
function start_service {
    local service=$1
    systemctl start "$service" && echo "Service $service started" || echo "Failed to start $service"
}

# Stop a system service
function stop_service {
    local service=$1
    systemctl stop "$service" && echo "Service $service stopped" || echo "Failed to stop $service"
}

# Show disk usage
function check_disk_usage {
    df -h
}

# Monitor system processes in real-time
function monitor_processes {
    top -n 1
}

# Analyze recent system logs (critical errors)
function analyze_logs {
    journalctl -p 3 -n 10 --no-pager
}

# Backup files from a specified directory
function backup_files {
    local source_dir=$1
    local dest_dir="/backup/$(basename "$source_dir")"
    rsync -av --progress "$source_dir" "$dest_dir" && echo "Backup completed to $dest_dir" || echo "Backup failed"
}

# Parse commands
case "$1" in
    --help)
        show_help
        ;;
    --version)
        show_version
        ;;
    service)
        case "$2" in
            list)
                list_services
                ;;
            start)
                start_service "$3"
                ;;
            stop)
                stop_service "$3"
                ;;
            *)
                echo "Unknown service command"
                ;;
        esac
        ;;
    system)
        case "$2" in
            load)
                show_load
                ;;
            *)
                echo "Unknown system command"
                ;;
        esac
        ;;
    disk)
        case "$2" in
            usage)
                check_disk_usage
                ;;
            *)
                echo "Unknown disk command"
                ;;
        esac
        ;;
    process)
        case "$2" in
            monitor)
                monitor_processes
                ;;
            *)
                echo "Unknown process command"
                ;;
        esac
        ;;
    logs)
        case "$2" in
            analyze)
                analyze_logs
                ;;
            *)
                echo "Unknown logs command"
                ;;
        esac
        ;;
    backup)
        backup_files "$2"
        ;;
    *)
        echo "Unknown command: $1"
        show_help
        ;;
esac
