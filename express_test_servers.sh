#!/bin/bash

servers=("usat" "usmi2" "usmi" "usda" "uslp" "usla2" "usse" "usde" "ussl1" "usta1" "usph" "usnj2" "usda2" "cava" "cato2" "camo" "br2" "br" "ukmi" "ukwe" "nlam" "im" "defr3" "esma" "am")  # Add your list of server locations here
connect_timeout=10  # Set the connection timeout in seconds
reconnect_interval=500 #Set the interval time in seconds
while true; do
    for server in "${servers[@]}"; do
        echo "Connecting to $server..."
        expressvpn disconnect  # Disconnect if already connected

        # Attempt to connect to the server with a timeout
        expressvpn connect $server &
        pid=$!  # Get the process ID of the command

        # Wait for connection attempt with a timeout
        for ((i = 0; i < connect_timeout; i++)); do
            sleep 1
            if ! kill -0 $pid 2>/dev/null; then
                echo "Failed to connect to $server within $connect_timeout seconds. Trying the next server..."
                break
            fi

            connected=$(expressvpn status | grep "Connected")
            if [ -n "$connected" ]; then
                echo "Connected to $server. Waiting for $reconnect_interval seconds..."
                sleep $reconnect_interval
                break   # Break out of both loops if connected
            fi
        done
    done
done

