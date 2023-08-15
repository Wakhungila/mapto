#!/bin/bash

# Check if the script is run with root privileges (EUID is 0)
if [ "$EUID" -ne 0 ]; then
    echo "This script requires root privileges. Please run with 'sudo'."
    exit 1
fi

# Function to print colored text using ANSI escape codes
print_colored_text() {
    local color_code=$1
    shift
    echo -e "\e[${color_code}m$@\e[0m"
}

# Function to handle keyboard interrupt
keyboard_interrupt() {
    echo -e "\nKeyboard interrupt. Exiting."
    exit 1
}

# Set trap for SIGINT (Ctrl+C)
trap keyboard_interrupt SIGINT

# Custom ASCII art with name and color
custom_art=$(cat << "EOF"
#     _____                    __          
#    /     \  _____   ______ _/  |_  ____  
#   /  \ /  \ \__  \  \____ \\   __\/  _ \ 
#  /    Y    \ / __ \_|  |_> >|  | (  <_> )
#  \____|__  /(____  /|   __/ |__|  \____/ 
#          \/      \/ |__|                 
#               By: Victor Wakhungila
		Twitter: @_Wakhoo_
EOF
)

# Print colored custom ASCII art in orange (ANSI code 33)
print_colored_text "33;1" "$custom_art"

# Prompt user to enter the target site
read -p "Enter the target site for scanning: " target_site

# Loading animation function
loading_animation() {
    local duration=0.2
    local animation="-\\|/"
    for (( i = 0; i < 10; i++ )); do
        echo -en "\rScanning... ${animation:i%${#animation}:1}"
        sleep $duration
    done
    echo -e "\rScanning... Done!"
}

# Add extra empty lines after Step 1 prompt and after Step 1 is completed
echo -e "Step 1: Scanning the target network..."
loading_animation
nmap -T4 -A $target_site

# Add extra empty lines after Step 2 prompt and after Step 2 is completed
echo -e "\nStep 2: Scanning web server for vulnerabilities..."
loading_animation
nikto -h $target_site

echo "Vulnerability assessment completed."

