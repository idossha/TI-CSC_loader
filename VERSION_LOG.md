### General To-Do List
- [ ] MATLAB .png output comes empty on macOS intel.
    1. error: MATLAB experienced a low level graphics error, and may not have drawn correctly.
- [ ] Create a GUI for the Application
- [ ] Develop a GUI solution for Apple Silicon.
- [ ] Multipolar Optimization
- [ ] Add directionality measurement for ana
- [ ] Add ROI analysis for patches of the cortex using different atlases.

## [Version 1.3.1] - 2024-10-31

### Added
- yank plugin to .tmux.conf to allow copy/paste functionality within tmux
- color scheme to analyzer&optimizer prompts
- better error catching & handling for optimizer

## [Version 1.3.0] - 2024-10-20

### Added
- FSL GUI functionality

### Changed
- new dockerfile architecture for all three images
- Implemented new loader program for docker compose with automatic system detection. 

## [Version 1.2.8] - 2024-10-16

### Added
- parcellation of White Matter

### Changed
- sphere-analysis & sphere-create, made sure not temp file lingering and enhanced debugging output
- `GM_extract.py` now named `field_extract.py` due to both GM & WM present


## [Version 1.2.7] - 2024-10-16

### Changed
- visualize-montage.sh now works perfect for both U & M simulations. 
- more debugging echos throughout analyzer
- Better prompting for ROI selection in optimizer

## [Version 1.2.6] - 2024-10-15

### Added 
- Added automatic ROI sphere niftii file (under sim_subjectID/niftis/) for visualization

### Changed
- fixed AMV script to work for multipolar
- minor changes to promping of analyzer
- imporved error catching to user inputs in analyzer

## [Version 1.2.5] - 2024-10-14

### Added
- Automatic high-density EGI net co-registration as part of the `charm` function

### Changed
- fixed `utils_dir` problem. Now the user does not have to have a predefined `utils_dir`
- removed automatic .csv opening at the end of optimizer

## [Version 1.2.4] - 2024-10-10

### New
- Now available in docker-compose version for faster push/pull process and reduced machine requirements.
- newer freesurfer version 7.1.1 -> 7.4.1

### Added
- bs2sn.py, for co-registration (utils)
- dwi2dti.sh, for DTI preprocessing (utils)
- dcm2niix package for DICOM prep

### Changed
- mTI.py, fixed mTI functionality in analyzer
- location of license.txt for freesurfer useage

## [Version 1.2.3] - 2024-10-03

### Added
- added progression system of optimization. ex: 001/150.
- Eliminated NVIM popups & removed lsp.

## [Version 1.2.2] - 2024-10-02

### Added
- pip3 install meshio & nibabel in dockerfile
- added automatic montage visualization + imagemagick library
- added asset directory. ti-csc/assets/

## [Version 1.2.1] - 2024-09-05

### Added
- utils_dir automatic addition to local project_dir if not present for analyzer
- added utils directory for TI-CSC toolbox.

## [Version 1.2.0] - 2024-09-03

### Added
- Normal components assessment for optimizer
- Terms of use GNU (license)
- Citations request and open source acknowledgments (readme)

### Changed
- Moved ROIs directory from under optimizer to local project dir, and made it subject specific for higher accuracy.
- Moved placement for ROI & Montage JSONs in analyzer to local project dir

---

## [Version 1.1.1] - 2024-08-29

### Added
- Automatic `T1_subjectID_MNI.nii.gz` creation for personalized visualization.
- Can now run multiple subjects in optimizer
- utils directory with `sphere-creater.py`

### Changed
- Subject prompting process in optimizer 
- User is not prompt to input project directory. Script does it automatically.

### Removed
- debugging output from `sphere-analysis.sh`

---

## [VERSION 1.1.0] - 2024-08-24

### Added
- MATLAB runtime now works on Apple silicon machines.

### Changed
- bash script to load image now changed from `start_TI_docker.sh` to `img-loader.sh`

#### Reference
- [WSL Issue #286 on GitHub](https://github.com/microsoft/WSL/issues/286) - Follow the `metorm` comment.
- Recompile MATLAB as suggested by `Shubham` in MATLAB Central.

