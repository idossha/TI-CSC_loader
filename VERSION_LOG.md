### To-Do List in order of importance

- [x] Figure out why MATLAB Runtime does not work on Apple Silicon.
- [x] Enhance optimizer prompting to behave similarly to the analyzer.
- [ ] create a utils dir in project dir if not present
- [ ] Automatic montage visualization.
    1. create a subdirectory called: `Presentation_material` 
    2. have an image of the net with the montage marked with the channels
    3. name and title should correspond to montage+subject_name
- [ ] Develop a GUI solution for Apple Silicon.
- [ ] MATLAB .png output comes empty on macOS intel.
    1. error: MATLAB experienced a low level graphics error, and may not have drawn correctly.
    2. libGL error: failed to load driver: swrast
- [x] Improve placement for ROI & Montage JSONs.
- [ ] Add ROI analysis for patches of the cortex using different atlases.
- [ ] Add a tool to do EEG-Cap co-registration
    1. either with brainstorm function or with SimNIBS function
    2. Must have a GUI or some sort of automatic visual confirmation
- [x] Add directionality measurement for Opt
- [ ] Add directionality measurement for ana
- [ ] Multipolar Optimization
- [ ] Clean `main-mTI.sh` script. Unnecessary local variables. 
- [ ] Solve FSL GUI problem.
- [ ] Create an in-house FSL image based on Ubuntu 20.04.
- [ ] Create an in-house Freesurfer image, version 7.4.1.
- [ ] Eliminate NVIM popups.
- [ ] Create a GUI for the Application

---

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

---
