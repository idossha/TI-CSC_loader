#!/bin/bash

# Set script directory
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
cd "$SCRIPT_DIR"

# Function to check allocated Docker resources (CPU, memory, and swap)
check_docker_resources() {
  echo "Checking Docker resource allocation..."

  if docker info > /dev/null 2>&1; then
    # Get Docker's memory and CPU allocation
    MEMORY=$(docker info | grep 'Total Memory' | awk '{print $3, $4}')
    CPU=$(docker info | grep 'CPUs' | awk '{print $2}')
    
    echo "Docker Memory Allocation: $MEMORY"
    echo "Docker CPU Allocation: $CPU"
  else
    echo "Docker is not running or not installed. Please start Docker and try again."
    exit 1
  fi
}

# Function to validate and prompt for the project directory
get_project_directory() {
  while true; do
    echo "Give path to local project dir:"
    read LOCAL_PROJECT_DIR

    if [[ -d "$LOCAL_PROJECT_DIR" ]]; then
      echo "Project directory found."
      break
    else
      echo "Invalid directory. Please provide a valid path."
    fi
  done
}

# Check if docker-compose.yml exists in the current directory
if [[ ! -f "$SCRIPT_DIR/docker-compose.yml" ]]; then
  echo "Error: docker-compose.yml not found in $SCRIPT_DIR. Please make sure the file is present."
  exit 1
fi

echo " "
# Allow local root access to X server
xhost +local:root
echo " "
echo "#####################################################################"
echo "Welcome to the TI toolbox from the Center for Sleep and Consciousness"
echo "Developed by Ido Haber as a wrapper around Modified SimNIBS"
echo " "
echo "Fully compatible with macOS (Intel/ARM chips), Linux, and Windows"
echo "Make sure you have XQuartz (on macOS) or X11 running."
echo "If you wish to use the optimizer, consider allocating more RAM to Docker."
echo "#####################################################################"
echo " "

# Validate and prompt for the local project directory
get_project_directory

# Extract the project directory name from the provided path
PROJECT_DIR_NAME=$(basename "$LOCAL_PROJECT_DIR")

# Check allocated Docker resources
check_docker_resources

# Set environment variables for macOS
echo "Assuming macOS setup..."
echo "Checking processor type..."
PROC_TYPE=$(uname -m)

if [[ "$PROC_TYPE" == "x86_64" || "$PROC_TYPE" == "arm64" ]]; then
  echo "Detected processor: $PROC_TYPE."
  DISPLAY_ENV="host.docker.internal:0"
else
  echo "Unsupported processor type: $PROC_TYPE. Please make sure your system supports Docker GUI functionality."
  exit 1
fi

# Set up Docker Compose environment variables
export DISPLAY=$DISPLAY_ENV
export LOCAL_PROJECT_DIR=$LOCAL_PROJECT_DIR
export PROJECT_DIR_NAME=$PROJECT_DIR_NAME

# Run Docker Compose
docker-compose -f "$SCRIPT_DIR/docker-compose.yml" up --build -d

# Attach to the simnibs container with an interactive terminal
docker exec -ti simnibs_container bash

# Stop and remove all containers when done
docker-compose -f "$SCRIPT_DIR/docker-compose.yml" down

# Revert X server access permissions
xhost -local:root
