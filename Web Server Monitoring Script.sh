#!/bin/bash

# Define the output file
OUTPUT_FILE="/var/log/web_server_performance.log"

# Function to get the current date and time
get_datetime() {
    date "+%Y-%m-%d %H:%M:%S"
}

# Function to get the current connected clients
get_connected_clients() {
    netstat -an | grep ':80 ' | grep 'ESTABLISHED' | wc -l
}

# Function to get the CPU usage
get_cpu_usage() {
    top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'
}

# Function to get the memory usage
get_memory_usage() {
    free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }'
}

# Function to get the bandwidth utilization
get_bandwidth_utilization() {
    sar -n DEV 1 1 | grep Average | grep wlan0 | awk '{print "RX: " $5 " Mbps, TX: " $6 " Mbps"}'
}

# Function to log the performance metrics
log_performance_metrics() {
    DATETIME=$(get_datetime)
    CONNECTED_CLIENTS=$(get_connected_clients)
    CPU_USAGE=$(get_cpu_usage)
    MEMORY_USAGE=$(get_memory_usage)
    BANDWIDTH=$(get_bandwidth_utilization)

    echo "$DATETIME - Clients: $CONNECTED_CLIENTS, CPU: $CPU_USAGE, Memory: $MEMORY_USAGE, Bandwidth: $BANDWIDTH" >> $OUTPUT_FILE
}

# Main loop
while true; do
    log_performance_metrics
    sleep 60  
done