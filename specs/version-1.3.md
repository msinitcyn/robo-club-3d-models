# Version 1.3 - LEGO Compatibility Improvements

Improvements to make parts better compatible with standard LEGO dimensions

## Changes Checklist

- [ ] **1. Adjust LEGO base dimensions to match standard LEGO parts**
  - Files: All `lego_base_*.scad` files (including `_double` variants)
  - Changes in `maze/scad/lego.scad`:
    - Add new constants for LEGO-compatible dimensions
    - `LEGO_BASE_WIDTH` - width for single row of studs (≈8mm, to be tuned)
    - `LEGO_SLEEVE_LENGTH` - calculated to have exactly 7 studs total (center + sleeve) with equal margins from edges
    - Update modules to use new dimensions
  - Reason: Current parts too wide to attach to multi-row LEGO bricks

- [ ] **2. Create prototype with reduced base width**
  - File: `maze/scad/cross_joint_dowel_8_5_base_width.scad`
  - Change: `CENTER_SIZE = 8.5` (instead of 9.0)
  - Version tag: `v1.3.2-base.8.5.mm.proto`
  - Reason: Test if 8.5mm base fits better into 12.5mm grid holes (currently loose fit)
  - Note: Temporary experimental part - if successful, apply to all parts; if too tight, delete

## Implementation Notes

### For Change 1:
- Center should have 1 stud
- Each sleeve should have 3 studs
- Total: 1 + 3 + 3 = 7 studs
- Edge margins should be equal on both sides
- Formula: `LEGO_SLEEVE_LENGTH = 3 * LEGO_UNIT + margins`

### For Change 2:
- Single file to test reduced base size
- If approved, will become standard in future version
- If rejected, will be deleted
