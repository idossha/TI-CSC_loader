
#!/bin/bash

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
echo "If you wish to use the optimizer with hd-EEG, consider allocating more RAM to docker"
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

# Run the Docker container based on the user's OS
if [[ "$OS_TYPE" == "Linux" ]]; then
  docker run --rm -ti \
    -e DISPLAY=$DISPLAY \
    -e LIBGL_ALWAYS_SOFTWARE=1 \
    -e PROJECT_DIR_NAME="$PROJECT_DIR_NAME" \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v "$LOCAL_PROJECT_DIR":/mnt/"$PROJECT_DIR_NAME" \
    idossha/ti-package:v1.2.2 bash -c "echo 'Your project was mounted to /mnt/$PROJECT_DIR_NAME' && bash"

elif [[ "$OS_TYPE" == "macOS" ]]; then
  # Prompt for processor type if macOS
  echo "Are you using an Intel/AMD processor or Apple Silicon (ARM)? (Enter 'Intel' or 'ARM'):"
  read PROC_TYPE

  if [[ "$PROC_TYPE" == "Intel" ]]; then
    DISPLAY=host.docker.internal:0
    docker run --rm -ti \
      -e DISPLAY=$DISPLAY \
      -e PROJECT_DIR_NAME="$PROJECT_DIR_NAME" \
      -v /tmp/.X11-unix:/tmp/.X11-unix \
      -v "$LOCAL_PROJECT_DIR":/mnt/"$PROJECT_DIR_NAME" \
      idossha/ti-package:v1.2.2 bash -c "echo 'Your project was mounted to /mnt/$PROJECT_DIR_NAME' && bash"

  elif [[ "$PROC_TYPE" == "ARM" ]]; then
    DISPLAY=docker.for.mac.host.internal:0
    docker run --rm -ti \
      -e DISPLAY=$DISPLAY \
      -e PROJECT_DIR_NAME="$PROJECT_DIR_NAME" \
      -v /tmp/.X11-unix:/tmp/.X11-unix \
      -v "$LOCAL_PROJECT_DIR":/mnt/"$PROJECT_DIR_NAME" \
      idossha/ti-package:v1.2.2 bash -c "echo 'Your project was mounted to /mnt/$PROJECT_DIR_NAME' && bash"

  else
    echo "Unsupported processor type. Please enter 'Intel' or 'ARM'."
  fi

elif [[ "$OS_TYPE" == "Windows" ]]; then
  echo "Make sure you have Xming running if you wish to use GUIs"
  echo "Enter the following command in your terminal:"
  echo "docker run --rm -ti -e DISPLAY=host.docker.internal:0.0 \ "
  echo "-e PROJECT_DIR_NAME=\"$PROJECT_DIR_NAME\"  -v "$LOCAL_PROJECT_DIR":/mnt/"$PROJECT_DIR_NAME" \ "
  echo " -v C:\path\to\project_dir:/mnt/project_dir idossha/ti-package:v1.2.2"
else
  echo "Unsupported OS type. Please enter 'Linux', 'macOS', or 'Windows'."
fi

# Revert X server access permissions
xhost -local:root

