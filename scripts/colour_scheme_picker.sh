#!/bin/bash

SCHEMES_DIR="$HOME/colour_schemes"

git -C "$SCHEMES_DIR" pull

DARK_SCHEME=$(grep --files-with-matches 'variant: "dark"' "$SCHEMES_DIR"/base16/*.yaml | shuf -n 1)

python3 - "$DARK_SCHEME" "$HOME/theme_templates" "$OUTPUT_DIR" << 'EOF'
import sys, os, yaml, chevron

scheme_file, template_directory, output_directory = *(sys.argv)

with open(scheme_file) as f:
    data = yaml.safe_load(f)

context = {f"{colour_key}-hex": colour for colour_key, colour in data.items() if colour_key.startswith("base")}
context["scheme-name"] = data.get("scheme", "Custom")

for root, _, files in os.walk(template_directory):
    for file in files:
        if file.endswith(".mustache"):
            src = os.path.join(root, file)
            # Remove .mustache extension for destination filename
            rel_path = os.path.relpath(src, template_directory)
            dest = os.path.join(output_directory, rel_path[:-9])
            
            os.makedirs(os.path.dirname(dest), exist_ok=True)
            with open(src) as f_in, open(dest, "w") as f_out:
                f_out.write(chevron.render(f_in, context))
EOF

exit 0
