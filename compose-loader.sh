#!/bin/bash

# Set script directory
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
cd "$SCRIPT_DIR"

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

# Function to validate and prompt for the project directory
get_project_directory() {
  while true; do
    echo "Give path to local project dir:"
    read -r LOCAL_PROJECT_DIR

    if [[ -d "$LOCAL_PROJECT_DIR" ]]; then
      echo "Project directory found."
      break
    else
      echo "Invalid directory. Please provide a valid path."
    fi
  done
}

# Function to set DISPLAY environment variable based on OS and processor type
set_display_env() {
  echo "Detecting operating system..."

  OS_TYPE=$(uname -s)

  case "$OS_TYPE" in
  Linux*)
    echo "Operating System: Linux"
    DISPLAY_ENV="$DISPLAY"
    ;;
  Darwin*)
    echo "Operating System: macOS"
    # Detect processor type
    PROC_TYPE=$(uname -m)
    echo "Detected processor: $PROC_TYPE."

    if [[ "$PROC_TYPE" == "x86_64" ]]; then
      DISPLAY_ENV="host.docker.internal:0"
    elif [[ "$PROC_TYPE" == "arm64" ]]; then
      # For Apple Silicon (ARM)
      DISPLAY_ENV="docker.for.mac.host.internal:0"
    else
      echo "Unsupported processor type: $PROC_TYPE. Please ensure your system supports Docker GUI functionality."
      exit 1
    fi
    ;;
  CYGWIN* | MINGW* | MSYS*)
    echo "Operating System: Windows"
    echo "Make sure you have Xming or VcXsrv running if you wish to use GUIs."
    DISPLAY_ENV="host.docker.internal:0.0"
    ;;
  *)
    echo "Unsupported Operating System: $OS_TYPE. Please use Linux, macOS, or Windows."
    exit 1
    ;;
  esac

  export DISPLAY=$DISPLAY_ENV
  echo "DISPLAY set to $DISPLAY"
}

# Function to validate docker-compose.yml existence
validate_docker_compose() {
  if [[ ! -f "$SCRIPT_DIR/docker-compose.yml" ]]; then
    echo "Error: docker-compose.yml not found in $SCRIPT_DIR. Please make sure the file is present."
    exit 1
  fi
}

# Function to display welcome message
display_welcome() {
  echo " "
  # Allow local root access to X server
  xhost +local:root
  echo " "
  echo "#####################################################################"
  echo "Welcome to the TI toolbox from the Center for Sleep and Consciousness"
  echo "Developed by Ido Haber as a wrapper around Modified SimNIBS"
  echo " "
  echo "Fully compatible with Linux, Windows, macOS (Intel/ARM chips)"
  echo "GUI functionality is not supported for macOS Silicon chip"
  echo " "
  echo "Make sure you have XQuartz (on macOS), X11 (on Linux), or Xming/VcXsrv (on Windows) running."
  echo "If you wish to use the optimizer, consider allocating more RAM to Docker."
  echo "#####################################################################"
  echo " "
}

# Function to run Docker Compose and attach to simnibs container
run_docker_compose() {
  # Run Docker Compose
  docker-compose -f "$SCRIPT_DIR/docker-compose.yml" up --build -d

  # Wait for containers to initialize
  sleep 5

  # Check if simnibs service is up
  if ! docker-compose ps | grep -q "simnibs"; then
    echo "Error: simnibs service is not running. Please check your docker-compose.yml and container logs."
    docker-compose logs
    exit 1
  fi

  # Attach to the simnibs container with an interactive terminal
  echo "Attaching to the simnibs_container..."
  docker exec -ti simnibs_container bash

  # Stop and remove all containers when done
  docker-compose -f "$SCRIPT_DIR/docker-compose.yml" down

  # Revert X server access permissions
  xhost -local:root
}

# Main Script Execution

validate_docker_compose
display_welcome
get_project_directory
PROJECT_DIR_NAME=$(basename "$LOCAL_PROJECT_DIR")
check_docker_resources
set_display_env

# Set up Docker Compose environment variables
export LOCAL_PROJECT_DIR
export PROJECT_DIR_NAME

run_docker_compose
