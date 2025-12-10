# 3D Models for Robotics Club

![Build STL Files](https://github.com/msinitcyn/robo-club-3d-models/actions/workflows/build-stl.yml/badge.svg)

## Project: Robot Maze

### System Description

Building a maze for teaching robot navigation. The system consists of:

**Base:**
- Holes diameter: 5mm
- Grid spacing: 12.5mm
- Mounting points for wall connectors

**Walls:**
- Material: plywood (9mm) or cardboard (2mm)
- Shape: rectangles cut to size
- Insert into connector grooves
- For cardboard use models with `_flexible` suffix

**3D-printed connectors:**
- Height: 10mm
- Wall thickness: 2mm
- Groove width: 9mm (for plywood)
- Reach to mounting hole: 56.5mm (4.5 grid steps)

### Connector Types

1. **end_cap** - end cap (1 exit)
2. **straight_joint** - straight connector (2 opposite exits)
3. **corner_joint** - corner (2 exits at 90°)
4. **t_joint** - T-shaped (3 exits)
5. **cross_joint** - cross (4 exits)

Each type available in 4 variants:
- Base (no dowels, for plywood)
- `_dowel` (with dowels for base mounting)
- `_flexible` (flexible walls for cardboard, no dowels)
- `_dowel_flexible` (flexible walls + dowels)

**Total: 20 models**

### Project Structure

```
maze/
  scad/           # OpenSCAD source files
    common.scad   # Common modules and functions
    *_joint*.scad # Different connector types
  stl/            # Locally built STL (in .gitignore)
artifacts/        # CI/CD artifacts (automatic)
  current/        # Latest build from main branch
  v1.0/           # Version builds (for tags)
.github/
  workflows/      # GitHub Actions for auto-build
```

### Getting Ready STL Files

**Option 1: Download from GitHub (recommended)**
- Latest version: `artifacts/current/` in repository
- Stable version: [Releases](../../releases) → download attached STL files

**Option 2: Build locally**
```bash
./export_all_stl.sh
```
STL files will appear in `maze/stl/`

### Usage

1. Download STL files from `artifacts/current/` or [Releases](../../releases)
2. Print needed connectors
3. Prepare walls from plywood (9mm) or cardboard (2mm)
4. Assemble maze by inserting walls into connector grooves

### Development

1. Edit models: `maze/scad/*.scad` files in OpenSCAD
2. Test locally: `./export_all_stl.sh`
3. Commit changes → GitHub Actions automatically builds STL
4. For release: create tag `git tag v1.1 && git push origin v1.1`

### Parameters for Modification

In `common.scad` you can configure:

**Main dimensions:**
- `CENTER_SIZE = 9` - center square size
- `SLEEVE_REACH = 56.5` - distance to mounting hole
- `GROOVE_WIDTH = 9` - groove width (for plywood)
- `WALL_HEIGHT = 10` - wall height
- `WALL_THICKNESS = 2` - wall thickness
- `BASE_THICKNESS = 2` - base thickness

**Dowels:**
- `DOWEL_DIAMETER = 4.5` - dowel diameter
- `DOWEL_DEPTH = 3` - dowel depth

**Flexible walls (for cardboard):**
- `CARDBOARD_THICKNESS = 2` - cardboard thickness
- `FLEXIBLE_WALL_HEIGHT = 20` - flexible wall height (2x higher)
- `CURVE_POWER = 2` - curve power (2 = parabola)
- `TILT_ANGLE_EXTRA = 5` - additional tilt angle

### CI/CD Pipeline

On push to GitHub, STL build is triggered automatically:

**For regular commits (main branch):**
- All STL files are built
- Committed to `artifacts/current/`
- Available as GitHub Artifacts (90 days)

**For version tags (v1.0, v1.1, etc.):**
- All STL files are built
- GitHub Release is created with attached STL
- Available as GitHub Artifacts with version name

This allows to always have print-ready files without need for local OpenSCAD installation.
