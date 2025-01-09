
# TI-CSC Toolbox for Docker Image

**Developed and maintained by Ido Haber - [ihaber@wisc.edu](mailto:ihaber@wisc.edu)**  
**Last update: January 8, 2025**

---

### Overview

The TI-CSC Toolbox is designed for researchers and engineers involved in Temporal Interference (TI) stimulation. This CLI-based toolbox facilitates the optimization of montages and the analysis of unipolar and bipolar montages. All dependencies are preinstalled & configured using docker, to facilitate easy of use and collaboration.

### Container Contents

The Docker container includes the following tools and libraries:

- **FSL** 6.0.6
- **Freesurfer** 7.4.1
- **SimNIBS** 4.1.0
- **dcm2niix**
- **MATLAB Runtime** r2024a
- Git repository with analysis and optimization scripts
- Commonly used CLI tools: VIM, NVIM, TMUX, Git, and more.

---

### Compatibility

- **Operating Systems:** Linux, Windows, macOS
- Please reach out if you encounter any bugs or issues.

---

### How to Run the Docker Container

1. **Ensure Docker is Installed:**
   - Download and install [Docker Desktop](https://www.docker.com/products/docker-desktop) for macOS and Windows, or [Docker Engine](https://docs.docker.com/engine/install/) for Linux.

2. **Set Up XQuartz or Xming:**
   - For macOS: Install [XQuartz](https://www.xquartz.org/).
   - For Windows: Install [Xming](https://sourceforge.net/projects/xming/).
   - *Note: These are only necessary if you plan to use GUI functionality.*
   - macOS tends to be GUI problematic. It is **highly recommanded** to run the `config_sys.sh` script before trying the run the containers. Also, consider downgrading Xquartz to an older version.


3. **Set Up Project Directory:**
   - Ensure your project directory follows this structure:
     ```
        ├── MRIs/
        │   ├── 001/
        │   │   ├── T1.nii
        │   │   └── T2.nii
        │   └── 002/
        │       ├── T1.nii
        │       └── T2.nii

     ```

4. **Run the Docker Container:**
   - On Unix systems (Linux/macOS), use the provided starter bash script:
     ```sh
     bash compose-loader.sh   # Recommended.
     bash img-loader.sh       # A single large image which contains everything. 
     ```
   - On Windows, if you do not have bash available, run the following command manually:
     ```sh
     docker run --rm -ti -e DISPLAY=host.docker.internal:0.0 -v C:\path\to\project_dir:/mnt/project_dir -v "$LOCAL_PROJECT_DIR":/mnt/"$PROJECT_DIR_NAME" idossha/ti-package:vx.x.x
     ```
   - *Replace `C:\path\to\project_dir` with the actual path to your project directory on Windows.*


    
#### Alternative option for Windows users:

1. Install Ubuntu environment from Windows Store
2. Git clone `TI-CSC_loader` to ubuntu
3. Install docker engine:

```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

4. run the following commands:
```bash
sudo usermod 0aG docker $USER
newgrp docker
docker ps
```

5. Load toolbox


---

### Tips

- **Automatic Screenshots:**  
  If you wish to enable automatic screenshots in the main scripts, simply uncomment the relevant lines in the script files.

- **Clearing Previous Outputs:**  
  Before re-executing analysis or optimization, it is highly recommended to clear or remove previous outputs to avoid conflicts.

- **MATLAB Runtime Warnings:**  
  MATLAB Runtime may display warnings, but they generally do not affect the correctness of the output.

---

#### To create head models

1. locate you MR scans
  * If these are DICOM, use `dcm2niix` function from the command line to transform to niftis
  * Once you have your niftis in place, use the `charm` function from SimNIBS to reconstruct the head model and co-register EEG nets.
  * Once `m2m_subjectID` is created, make sure it is placed under `/project_dir/Subjects/`
  * You can move to the `analyzer` / `optimizer`
  * Your project_dir at this point should look like the following tree:
 
     ```
        ├── MRIs/
        │   ├── 001/
        │   │   ├── T1.nii
        │   │   └── T2.nii
        │   └── 002/
        │       ├── T1.nii
        │       └── T2.nii
        └── Subjects/
            ├── m2m_001/
            └── m2m_002/

     ```




#### Analyzer Requirements:

1. A project directory containing the `Subjects` subdirectory with `m2m_SubjectID` directories.
2. A tensor file (required only for anisotropic simulation).

**How to Run:**

```bash
bash start-ana.sh
```

Follow the on-screen prompts.  
If running multiple consecutive analyses, move the previous `sim_SubjectID` directory elsewhere before starting a new one.

### Optimizer Requirements:
A project directory containing the `Subjects` subdirectory with `m2m_SubjectID` directories.

**How to Run:**

```bash
bash start-opt.sh
```

Follow the on-screen prompts.  
First optimization for every subject will require you to create two leadfields which might take > 1h +
Following optimizations will automatically skip this step.
For hd-EEG optimization, allocate more RAM to Docker. Recommended: >32GB.

---


### If you are an inexperienced command line user:

Bash syntax:

`cd`            - change directory. helps you move around the tree structure. 
`pwd`           - present working directory. Gives you the path of where you are currently at. 
`ls`            - List all files/folders in your current position. 
`cat`           - Concatenates the file. Meaning, it prints out the content of it to the console. 
`vim file_name` - Allows you to edit text using vim editor.  
`which`         - Searches for the path of some executable. 

keyboard cntrl+c - Stop any process from the command line. 
keyboard tab     - Auto completion from the command line. 
keyboard arrows  -  Allows you to navigate thorugh history via up/down. Allows to edit a command by moving left/right. 
docker ps        - test to see if docker is running. 

---



Cheers,  
Ido Haber
