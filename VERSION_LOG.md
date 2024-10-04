### General To-Do List
- [ ] MATLAB .png output comes empty on macOS intel.
    1. error: MATLAB experienced a low level graphics error, and may not have drawn correctly.
    2. libGL error: failed to load driver: swrast
- [ ] Add a tool to do EEG-Cap co-registration
    1. either with brainstorm function or with SimNIBS function
    2. Must have a GUI or some sort of automatic visual confirmation
- [ ] Clean `main-mTI.sh` script. Unnecessary local variables. 
- [ ] Solve FSL GUI problem.
- [ ] Create an in-house FSL image based on Ubuntu 20.04.
- [ ] Create an in-house Freesurfer image, version 7.4.1.
- [ ] Create a GUI for the Application
- [ ] Develop a GUI solution for Apple Silicon.

### To be added once new SimNIBS version comes out
- [ ] Multipolar Optimization
- [ ] Add directionality measurement for ana

## [Version 1.2.4] - 2024-??-??
- [ ] Add ROI analysis for patches of the cortex using different atlases.
- [ ] add automatic ROI sphere niftii for visualization

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

