# Specification: LEGO-Compatible Modular System

## Concept

The system splits models into two layers connected via LEGO-compatible interface:

1. **Bottom Layer (Base)**
   - Optional dowels for mounting to grid base
   - LEGO studs on top for connecting upper layer

2. **Upper Layer (Wall Sleeve)**
   - LEGO holes underneath for connecting to base
   - Grooves on top for inserting plywood/cardboard walls

## Advantages

- **Modularity**: Print only the sleeves you need, attach to any base configuration
- **Flexibility**: Rigid walls (9mm plywood) or flexible walls (2mm cardboard)
- **Compatibility**: Can use real LEGO bricks for walls
- **Efficiency**: Empty center is normal - print 4 sleeves + 1 cross base for any configuration

## LEGO Standards

- Stud diameter: **4.8mm**
- Stud height: **1.8mm**
- Unit spacing: **8mm** (1 LEGO unit)
- Hole diameter: **5.0mm** (with clearance)
- Tube outer diameter: **6.5mm** (for spring grip)
- Tube inner diameter: **5.0mm**

## Dimensions

### Current Parameters
- `CENTER_SIZE = 9mm` (center square)
- `SLEEVE_LENGTH = 55mm` (actual sleeve length)
- `SLEEVE_REACH = 59.5mm` (calculated: from center to mounting hole)

### Stud Positions

**Formula:**
```
first_stud = LEGO_UNIT - (CENTER_SIZE/2 % LEGO_UNIT) = 8 - 4.5 = 3.5mm
```

**Center part:**
- 1 stud at center: **(0, 0)**

**Sleeve (local coordinates):**
- Sleeve starts at global coordinate **4.5mm** (edge of center square)
- Studs at local positions: **3.5, 11.5, 19.5, 27.5, 35.5, 43.5mm**

**Global coordinates (after assembly):**
- Center: **0mm**
- Sleeve: **8, 16, 24, 32, 40, 48mm**

**Verification:** All positions are multiples of 8mm ✓

### Visualization (top view, one sleeve along X axis)

```
    Center (9×9mm)    |      Sleeve (55mm)
                      |
    ----[═]----       |   [═]  [═]  [═]  [═]  [═]  [═]
        0mm           |   8   16   24   32   40   48
                    4.5mm (sleeve start)
```

## Module Structure

### Bottom Layer (Bases)
**File prefix:** `lego_base_*`

- `lego_base_straight[_dowel].scad` - straight base (center + 2 opposite sleeves)
- `lego_base_corner[_dowel].scad` - corner base (center + 2 sleeves at 90°)
- `lego_base_t[_dowel].scad` - T-shaped base (center + 3 sleeves)
- `lego_base_cross[_dowel].scad` - cross base (center + 4 sleeves)

**Variants:**
- Base (no dowels)
- `_dowel` (with dowels for grid mounting)

**Total:** 8 models

### Upper Layer (Wall Sleeves)
**File prefix:** `lego_wall_sleeve_*`

**Simple holes variant (for testing):**
- `lego_wall_sleeve.scad` - rigid walls (9mm plywood)
- `lego_wall_sleeve_flexible.scad` - flexible walls (2mm cardboard)

**Spring tubes variant (recommended):**
- `lego_wall_sleeve_tubes.scad` - rigid walls + inner tubes
- `lego_wall_sleeve_flexible_tubes.scad` - flexible walls + inner tubes

**Total:** 4 models

## Implementation Status

### ✅ Completed

1. **Code Architecture**
   - `common.scad` - base functionality for all models
   - `lego.scad` - LEGO-specific constants and modules (includes common.scad)
   - Constants refactored: SLEEVE_LENGTH is primary, SLEEVE_REACH is calculated

2. **Base Models (8 files)**
   - All 4 base configurations implemented
   - With/without dowel variants
   - LEGO studs positioned on 8mm grid
   - Z-offset parameterized for wall modules

3. **Wall Sleeve Models (4 files)**
   - Simple holes variant (5mm diameter holes)
   - Spring tubes variant (6.5mm outer, 5mm inner tubes)
   - Rigid and flexible wall variants for both
   - Base height = LEGO_STUD_HEIGHT (1.8mm)
   - Walls start at correct Z position

4. **LEGO Standards Compliance**
   - Stud positioning algorithm with boundary checks
   - Proper tube structure for spring grip
   - Holes penetrate full base thickness
   - Compatible with real LEGO bricks

### 🧪 Testing Required

- [ ] Print and test simple holes variant
- [ ] Print and test spring tubes variant
- [ ] Verify LEGO brick compatibility
- [ ] Test assembly/disassembly ease
- [ ] Check structural integrity

### 📋 Documentation

- [ ] Update main README with modular system description
- [ ] Add assembly instructions
- [ ] Document which variant to use when

## File Organization

```
maze/
  scad/
    common.scad           # Base functionality
    lego.scad             # LEGO-specific code

    # Base models (8 files)
    lego_base_straight.scad
    lego_base_straight_dowel.scad
    lego_base_corner.scad
    lego_base_corner_dowel.scad
    lego_base_t.scad
    lego_base_t_dowel.scad
    lego_base_cross.scad
    lego_base_cross_dowel.scad

    # Wall sleeve models (4 files)
    lego_wall_sleeve.scad                  # Simple holes, rigid
    lego_wall_sleeve_flexible.scad         # Simple holes, flexible
    lego_wall_sleeve_tubes.scad            # Spring tubes, rigid
    lego_wall_sleeve_flexible_tubes.scad   # Spring tubes, flexible

    # Legacy models (preserved)
    *_joint*.scad         # Original monolithic models
    end_cap*.scad
```

## Usage Example

1. Print `lego_base_cross.scad` → base with LEGO studs in cross pattern
2. Print 4× `lego_wall_sleeve_tubes.scad` → sleeves with rigid walls
3. Insert sleeves onto base via LEGO connection
4. Insert plywood walls (9mm) into grooves
5. Reconfigure anytime by swapping sleeves

## Technical Notes

### Boundary Checks
Studs are only placed if:
- First stud: `position >= LEGO_STUD_DIAMETER/2` from sleeve start
- Last stud: `position <= SLEEVE_LENGTH - LEGO_STUD_DIAMETER/2` from sleeve end

### Spring Tube Mechanism
- Tube height: 1.6mm (0.2mm below base surface)
- Stud (4.8mm) enters hole (5.0mm) inside tube
- Tube wall (0.75mm) deforms elastically
- Creates secure friction fit

### Z-Offset Parameter
All wall-drawing modules accept `z_offset` parameter:
- Legacy models: default `BASE_THICKNESS = 2mm`
- LEGO models: pass `LEGO_STUD_HEIGHT = 1.8mm`
- Allows mixing LEGO and non-LEGO components

## Legacy Compatibility

Original monolithic joint models are preserved:
- `straight_joint*.scad`
- `corner_joint*.scad`
- `t_joint*.scad`
- `cross_joint*.scad`
- `end_cap*.scad`

These continue to work with existing maze setups.

## Next Steps

1. Print test samples of both hole variants
2. Measure fit quality with real LEGO bricks
3. Adjust tolerances if needed (LEGO_HOLE_DIAMETER, LEGO_TUBE_OUTER_DIAMETER)
4. Update CI/CD to build new models
5. Create release with both variants
