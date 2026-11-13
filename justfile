default:
    @just --list

# Render the ornament in each test case and preset, and check its solids and size
test:
    python3 tests/test_ornament.py

# Render the README pictures into assets/, in Liberation Sans
images:
    @mkdir -p assets
    openscad --render --camera=0,3,0,0,0,0,235 --imgsize=600,640 --colorscheme=Tomorrow -D font_name=0 -D 'other_font="Liberation Sans"' -o assets/ornament.png src/ChristmasNameOrnament.scad
    openscad --render --camera=0,3,0,0,0,0,235 --imgsize=600,640 --colorscheme=Tomorrow -D font_name=0 -D 'other_font="Liberation Sans"' -D 'name="Christopher"' -o assets/ornament-long-name.png src/ChristmasNameOrnament.scad
