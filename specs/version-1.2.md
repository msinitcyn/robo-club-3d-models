# Version 1.2 - Print Test Improvements

Based on print testing feedback, the following improvements are planned for version 1.2

## Changes Checklist

- [x] **1. Increase LEGO stud diameter**
  - File: `maze/scad/lego.scad`
  - Change: `LEGO_STUD_DIAMETER` from 4.8mm to 5.0mm
  - Reason: Current studs don't hold parts or authentic LEGO bricks securely

- [x] **2. Move version stamp to top surface and increase size**
  - File: `maze/scad/version.scad`
  - Changes:
    - Move version engraving from bottom (z=0) to top surfaces
    - Increase font size from 1.0mm to 2.0mm
  - Reason: Bottom surface has support material and version is not visible

- [x] **3. Fix LEGO niche design**
  - File: `maze/scad/lego.scad`
  - Changes:
    - Reduce `LEGO_NICHE_WIDTH` from 5.0mm to 4.8mm
    - Replace cylindrical supports between studs with perpendicular walls
  - Reason: Cylinders break when removing support material; niche too wide (LEGO bricks are loose)

- [ ] **4. Increase dowel depth**
  - File: `maze/scad/common.scad`
  - Change: `DOWEL_DEPTH` from 3.0mm to 3.5mm
  - Reason: Dowels too short for secure mounting to base

- [ ] **5. Reduce groove width for plywood**
  - File: `maze/scad/common.scad`
  - Change: `GROOVE_WIDTH` from 9.0mm to 8.5mm
  - Reason: Groove too wide for 9mm plywood (walls are loose)

- [ ] **6. Create double-sided LEGO base series**
  - New files: 8 new .scad files
  - Feature: LEGO bases with studs on both top and bottom surfaces
  - Models:
    - lego_base_straight_double.scad
    - lego_base_straight_double_dowel.scad
    - lego_base_corner_double.scad
    - lego_base_corner_double_dowel.scad
    - lego_base_t_double.scad
    - lego_base_t_double_dowel.scad
    - lego_base_cross_double.scad
    - lego_base_cross_double_dowel.scad
  - Reason: Allow building maze structures in both directions
