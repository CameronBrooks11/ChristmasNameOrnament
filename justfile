default:
    @just --list

# Render the ornament in each test case and preset, and check its solids and size
test:
    python3 tests/test_ornament.py

# Render the README pictures into assets/
images:
    @mkdir -p assets
    openscad --render --camera=0,0,0,0,0,0,220 --imgsize=600,600 --colorscheme=Tomorrow -D font_name=0 -D 'other_font="Liberation Sans"' -o assets/ornament.png src/ChristmasNameOrnament.scad
    openscad --render --camera=0,0,0,0,0,0,220 --imgsize=600,600 --colorscheme=Tomorrow -D font_name=0 -D 'other_font="Liberation Sans"' -D 'name="Christopher"' -D 'text2="2026"' -D text2_font=0 -D 'text2_other_font="Liberation Sans"' -o assets/ornament-long-name.png src/ChristmasNameOrnament.scad
