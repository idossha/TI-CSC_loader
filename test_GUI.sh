
#!/bin/bash

# Function to check allocated Docker resources (CPU, memory)
check_docker_resources() {
  echo "Checking Docker resource allocation..."

  if docker info >/dev/null 2>&1; then
    # Get Docker's memory and CPU allocation
    MEMORY=$(docker info --format '{{.MemTotal}}')
    CPU=$(docker info --format '{{.NCPU}}')

    # Convert memory from bytes to GB
    MEMORY_GB=$(echo "scale=2; $MEMORY / (1024^3)" | bc)

    echo "Docker Memory Allocation: ${MEMORY_GB} GB"
    echo "Docker CPU Allocation: $CPU CPUs"
  else
    echo "Docker is not running or not installed. Please start Docker and try again."
    exit 1
  fi
}

# Function to get the IP address of the host machine
get_host_ip() {
  case "$(uname -s)" in
    Darwin)
      # Get the local IP address on macOS
      HOST_IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
      ;;
    Linux)
      # Get the local IP address on Linux
      HOST_IP=$(hostname -I | awk '{print $1}')
      ;;
    *)
      echo "Unsupported OS. Please use macOS or Linux."
      exit 1
      ;;
  esac
  echo "Host IP: $HOST_IP"
}

# Function to set DISPLAY environment variable based on OS and processor type
set_display_env() {
  echo "Setting DISPLAY environment variable..."

  get_host_ip  # Get the IP address dynamically

  # Set DISPLAY based on IP
  export DISPLAY="$HOST_IP:0"

  echo "DISPLAY set to $DISPLAY"
}

# Function to allow connections from XQuartz
allow_xhost() {
  echo "Allowing connections from XQuartz..."

  # Use the dynamically obtained IP or hostname for xhost
  xhost + "$HOST_IP"
}

# Function to run docker with GUI application
run_docker_container() {
  echo "Running Docker container with X11 forwarding..."
  docker run -e DISPLAY="$DISPLAY" --rm -it idinextel/miniraspbian xclock
}

# Main Script Execution

check_docker_resources
set_display_env
allow_xhost  # Allow X11 connections
run_docker_container
