# Customizable Christmas Name Ornament

This project is a revamped and improved version of the original customizable Christmas ornament generator. It allows you to create personalized ornaments with a variety of customization options, all designed to be easier to use and compatible with batch exporting tools for faster workflow.

## Features

- **Text Customization**: Add any text to your ornament in any font available on your system.
- **Snowflake Designs**: Choose from six different snowflake styles and place them in four set locations on the ornament.
- **Multi-Line Support**: Option to include a second line of text for additional personalization.
- **Batch Export Compatibility**: Fully compatible with batch exporting tools for streamlined production.
- **Multi-Color Printing**: Generate separate STL files for the ornament outline, background, text, and snowflakes, enabling easy multi-nozzle or single-nozzle dual-color printing.
- **Easy Scaling**: Default size is 79mm in diameter, but you can scale it to any size in your slicer.
- **Blank Templates**: Includes blank ornaments for custom designs in external software like Fusion 360.

## Getting Started

### Running the Customizer

You can run this customizer locally on your computer using [OpenSCAD](https://openscad.org):

1. Install OpenSCAD if you haven’t already.
2. Open the `.scad` file included in the repository.
3. Adjust the parameters in the customizer panel to fit your desired design.
4. Render and export your customized STL files.

### Font Configuration

To use custom fonts:

1. Install the desired font on your system.
2. Restart OpenSCAD to recognize the newly added font.
3. Select the font from the dropdown menu in the customizer panel.

### Multi-Color Printing

For multi-color prints:

1. Export the separate STL files for each part (outline, background, text, and snowflakes).
2. Load the files into your slicer and assign different colors to each part.
3. Use a dual-extruder or filament swapping techniques for a polished result.

## Tips for Best Results

- Use the **Skin Expand Distance** setting in Cura or equivalent settings in your slicer to ensure clean, continuous top layers.
- Add a small cylinder in the slicer to prime the nozzle when swapping filaments for single-extruder dual-color prints.
- Adjust the "Name Y Offset" parameter if text placement is misaligned in the preview.

## Acknowledgments

This project is based on the original customizable ornament by [Lyl3 on Thingiverse](https://www.thingiverse.com/thing:4681765). Improvements have been made to enhance usability and introduce compatibility with batch processing tools.

## License

This project is licensed under the [Creative Commons - Attribution - Share Alike](https://creativecommons.org/licenses/by-sa/4.0/) license. You are free to remix and share this project as long as you give appropriate credit and share your contributions under the same license.

## Feedback

If you have any suggestions, issues, or feedback, feel free to open an issue or submit a pull request. We welcome contributions to improve this project!
