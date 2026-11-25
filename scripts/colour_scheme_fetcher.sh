#!/usr/bin/env bash

THEME_DIRECTORY="$HOME/themes"

TEMPORARY_JSON_FILE=$(mktemp)
if ! curl --silent --show-error --fail --location --connect-timeout 10 "https://raw.githubusercontent.com/Gogh-Co/Gogh/master/data/themes.json" --output "$TEMPORARY_JSON_FILE" || [[ ! -s "$TEMPORARY_JSON_FILE" ]]; then
    rm -f "$TEMPORARY_JSON_FILE"
    exit 1
fi

rm -f "$THEME_DIRECTORY"/*.json

jq --compact-output '.[]' "$TEMPORARY_JSON_FILE" | while read -r theme; do

    NAME=$(echo "$theme" | jq --raw-output '.name')

    BACKGROUND_COLOURS=$(echo "$theme" | jq --raw-output '.background')
    BACKGROUND_HEXCODE=${BACKGROUND_COLOURS//#/}
    if [[ ${#BACKGROUND_HEXCODE} -ne 6 ]]; then # Just in case there is a shorthand 3-digit hex code present.
        continue
    fi

    if [[ $(( (16#${BACKGROUND_HEXCODE:0:2} * 299 + 16#${BACKGROUND_HEXCODE:2:2} * 587 + 16#${BACKGROUND_HEXCODE:4:2} * 114) / 1000 )) -lt 128 ]]; then # This condition basically checks whether the theme is dark or light, keeping only the dark ones.
        echo "$theme" | jq '{
            special: {
                background: .background,
                foreground: .foreground,
                cursor: .cursor
            },
            colors: {
                color0: .color_01,
                color1: .color_02,
                color2: .color_03,
                color3: .color_04,
                color4: .color_05,
                color5: .color_06,
                color6: .color_07,
                color7: .color_08,
                color8: .color_09,
                color9: .color_10,
                color10: .color_11,
                color11: .color_12,
                color12: .color_13,
                color13: .color_14,
                color14: .color_15,
                color15: .color_16
            }
        }' > "$THEME_DIRECTORY/$(echo "$NAME" | sed 's/[^a-zA-Z0-9]/_/g').json"
    fi

done

while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    if [[ -z "$line" ]]; then
        continue
    else
        theme_name=$(basename "$line" .json)
        rm -f "$THEME_DIRECTORY/$theme_name.json"
    fi
done < "$HOME/blacklisted_themes"

rm -f "$TEMPORARY_JSON_FILE"