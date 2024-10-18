#!/bin/bash

# setup_docker_gui.sh
# This script configures the environment for Docker Compose projects with GUI applications on macOS using XQuartz.

set -e  # Exit immediately if a command exits with a non-zero status.
set -u  # Treat unset variables as an error.

# Function to print debug messages
debug() {
    echo "[DEBUG] $1"
}

# Function to check if XQuartz is installed
check_xquartz() {
    debug "Checking if XQuartz is installed..."
    if ! command -v open &> /dev/null; then
        echo "Error: 'open' command not found. Are you on macOS?"
        exit 1
    fi

    # Check if XQuartz application exists
    if [ ! -d "/Applications/Utilities/XQuartz.app" ]; then
        echo "Error: XQuartz is not installed. Please install it from https://www.xquartz.org/ and try again."
        exit 1
    fi

    debug "XQuartz is installed."
}

# Function to check if XQuartz is running
check_xquartz_running() {
    if ! pgrep XQuartz > /dev/null; then
        echo "XQuartz is not running. Starting XQuartz..."
        open -a XQuartz
        sleep 5  # Wait for XQuartz to start
    else
        echo "XQuartz is already running."
    fi
}

# Function to configure XQuartz to allow network connections
configure_xquartz() {
    debug "Configuring XQuartz to allow network connections..."
    # Allow connections from network clients
    defaults write org.xquartz.X11 nolisten_tcp -bool false
    # Restart XQuartz to apply changes
    killall XQuartz || true
    open -a XQuartz
    sleep 5  # Wait for XQuartz to restart

    # Allow connections from localhost
    if ! command -v xhost &> /dev/null; then
        echo "Error: xhost command not found. Ensure XQuartz is properly installed."
        exit 1
    fi

    xhost + 127.0.0.1
    if [ $? -ne 0 ]; then
        echo "Error: Failed to set XQuartz permissions."
        exit 1
    fi
    debug "XQuartz configured to allow network connections."
}

# Function to get the host IP address accessible by Docker containers
get_host_ip() {
    debug "Retrieving host IP address for Docker containers..."
    # On macOS, Docker containers can access the host via 'host.docker.internal'
    HOST_IP="host.docker.internal"
    debug "Host IP set to $HOST_IP"
}

# Function to set DISPLAY environment variable
set_display() {
    debug "Setting DISPLAY environment variable..."
    export DISPLAY="host.docker.internal:0"
    echo "DISPLAY set to $DISPLAY"
}

# Function to determine shell and set the correct profile file
set_shell_profile() {
    SHELL_TYPE=$(basename "$SHELL")
    debug "Detected shell: $SHELL_TYPE"

    if [[ "$SHELL_TYPE" == "zsh" ]]; then
        SHELL_PROFILE="$HOME/.zshrc"
    elif [[ "$SHELL_TYPE" == "bash" ]]; then
        SHELL_PROFILE="$HOME/.bash_profile"
    else
        echo "Unsupported shell: $SHELL_TYPE. Please use bash or zsh."
        exit 1
    fi

    debug "Using shell profile: $SHELL_PROFILE"
}

# Function to export environment variables for future use
export_env_vars() {
    set_shell_profile  # Determine correct shell profile

    debug "Exporting environment variables for future Docker Compose usage..."

    ENV_VARS="export DOCKER_HOST_IP=$HOST_IP
export DISPLAY=$DISPLAY"

    echo "$ENV_VARS" >> "$SHELL_PROFILE"
    debug "Environment variables appended to $SHELL_PROFILE."

    # Source the profile to apply changes immediately
    source "$SHELL_PROFILE"
    debug "Environment variables exported to current session."

    echo "DOCKER_HOST_IP=$HOST_IP"
    echo "DISPLAY=$DISPLAY"
}

# Function to verify the configuration
verify_configuration() {
    debug "Verifying configuration..."

    # Check DISPLAY variable
    if [ -z "${DISPLAY:-}" ]; then
        echo "Error: DISPLAY environment variable is not set."
        exit 1
    else
        echo "DISPLAY is set to $DISPLAY"
    fi

    # Check if xhost allows connections
    xhost_output=$(xhost)
    if [[ $xhost_output != *"127.0.0.1"* ]]; then
        echo "Error: xhost does not allow connections from 127.0.0.1."
        exit 1
    else
        echo "xhost is correctly configured to allow connections from 127.0.0.1."
    fi

    # Test XQuartz with a simple GUI app (xclock)
    debug "Testing XQuartz with a simple GUI application (xclock)..."
    docker run -e DISPLAY=$DISPLAY --rm -it jess/x11 xclock &
    sleep 5  # Wait for xclock to display
    if pgrep xclock > /dev/null; then
        echo "XQuartz is working properly. GUI apps can connect."
        killall xclock  # Stop the test app
    else
        echo "Error: GUI apps could not connect to XQuartz. Please check your setup."
        exit 1
    fi

    echo "Configuration verification completed successfully."
}

# Main Execution Flow
echo "Starting Docker GUI setup script..."

check_xquartz
check_xquartz_running
configure_xquartz
get_host_ip
set_display
export_env_vars
verify_configuration

echo "Docker GUI setup completed successfully."

# Instructions for the user
echo "Next Steps:"
echo "1. Verify that the DISPLAY environment variable is set by running 'echo \$DISPLAY'."
echo "2. Ensure that XQuartz is running and accepting connections."
echo "3. When ready, you can proceed to launch Docker Compose with your project."
echo "   For example:"
echo "       docker-compose up -d"
echo "4. To stop the Docker containers, run 'docker-compose down'."

