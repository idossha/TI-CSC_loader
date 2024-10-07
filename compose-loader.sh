#!/bin/bash

# Set script directory
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
cd "$SCRIPT_DIR"

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
echo "Fully compatible with Linux, Windows, macOS w/ intel chip"
echo "GUI funtionality is not supported for macOS Silicon chip"
echo " "
echo "Make sure you have Xgraphics available and running."
echo "If you wish to use the optimizer, consider allocating more RAM to Docker."
echo "#####################################################################"
echo " "

# Prompt the user to input the path to the local project directory
echo "Give path to local project dir:"
read LOCAL_PROJECT_DIR

# Extract the project directory name from the provided path
PROJECT_DIR_NAME=$(basename "$LOCAL_PROJECT_DIR")

# Prompt the user to specify their operating system
echo "Are you running on Linux, macOS or Windows? (Example enter 'Linux'):"
read OS_TYPE

# Set environment variables based on the user's OS
if [[ "$OS_TYPE" == "Linux" ]]; then
  DISPLAY_ENV=$DISPLAY

elif [[ "$OS_TYPE" == "macOS" ]]; then
  # Prompt for processor type if macOS
  echo "Are you using an Intel/AMD processor or Apple Silicon (ARM)? (Enter 'Intel' or 'ARM'):"
  read PROC_TYPE

  if [[ "$PROC_TYPE" == "Intel" ]]; then
    DISPLAY_ENV="host.docker.internal:0"
  elif [[ "$PROC_TYPE" == "ARM" ]]; then
    DISPLAY_ENV="docker.for.mac.host.internal:0"
  else
    echo "Unsupported processor type. Please enter 'Intel' or 'ARM'."
    exit 1
  fi

elif [[ "$OS_TYPE" == "Windows" ]]; then
  echo "Make sure you have Xming running if you wish to use GUIs."
  DISPLAY_ENV="host.docker.internal:0.0"

else
  echo "Unsupported OS type. Please enter 'Linux', 'macOS', or 'Windows'."
  exit 1
fi

# Set up Docker Compose environment variables
export DISPLAY=$DISPLAY_ENV
export LOCAL_PROJECT_DIR=$LOCAL_PROJECT_DIR
export PROJECT_DIR_NAME=$PROJECT_DIR_NAME

# Run Docker Compose
docker-compose -f "$SCRIPT_DIR/docker-compose.yml" up --build -d

# Attach to the simnibs container with interactive terminal
docker exec -ti simnibs_container bash

# Stop and remove all containers when done
docker-compose -f "$SCRIPT_DIR/docker-compose.yml" down

# Revert X server access permissions
xhost -local:root
