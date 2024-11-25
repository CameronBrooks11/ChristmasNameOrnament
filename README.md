# ChristmasNameOrnament
Customizable Christmas ornament generator with options for text, fonts, snowflake designs, and multi-color 3D printing.


## Features

- **Custom Text and Fonts**: Add any text using fonts available on your system.
- **Snowflake Decorations**: Choose from six different snowflake designs and position them in multiple configurations.
- **Multi-Color Printing Support**: Easily create dual-color ornaments with single extruder printers.
- **Batch Export Compatibility**: Export multiple customized ornaments simultaneously for streamlined workflows.
- **Resizable Design**: Default diameter is 79 mm, but it can be scaled to any size in your slicer.

## Updates

- **Batch Export Compatibility**: Improved support for batch processing tools.
- **Enhanced User Interface**: Simplified parameters for faster customization.
- **Additional Features**:
  - Option for a second line of text.
  - Create ornaments without a background line or with separate STL files for multi-nozzle printing.

## Getting Started

### Running the Customizer

To create your custom ornaments:
1. Download and install [OpenSCAD](https://www.openscad.org/).
2. Open the `.scad` file in OpenSCAD.
3. Modify the parameters in the customizer interface.
4. Render and export your custom ornament as an STL file.

### Fonts

You can use any font installed on your system. To ensure compatibility:
1. Install fonts directly on your system or place font files in the same folder as the `.scad` file.
2. Restart OpenSCAD to refresh the font list.

### Batch Export

For batch exporting:
1. Use tools like [PrusaSlicer](https://www.prusa3d.com/prusaslicer/) or custom OpenSCAD scripts to process multiple configurations.
2. Export all designs in a single batch to save time.

## Printing Tips

- **Dual Colors with Single Extruder**:
  - Pause your print at the appropriate layer to swap filament colors.
  - Use the provided swap tower for priming the extruder during filament changes.
- **Slicer Settings**:
  - Set the top infill to a solid continuous print for a polished finish. In Cura, adjust the `Skin Expand Distance` to a high value (e.g., 10 mm).
