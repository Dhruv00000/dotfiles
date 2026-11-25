#!/usr/bin/env bash

swaylock "$@" \
 --font "JetBrainsMono Nerd Font" \
 --line-uses-inside \
 --indicator-radius 100 \
 --screenshots --color {{background | strip}} --effect-blur 20x2 --effect-compose "0,0;100%x100%;northwest;$HOME/.config/swaylock/lock-overlay.svg" \
 --bs-hl-color {{color1 | strip}} --key-hl-color {{foreground | strip}} \
 --indicator-caps-lock --inside-caps-lock-color {{color3 | strip}} --caps-lock-bs-hl-color {{color1 | strip}} --caps-lock-key-hl-color {{color2 | strip}} \
 --inside-color {{background | strip}} --inside-clear-color {{color3 | strip}} --inside-wrong-color {{color1 | strip}} --inside-ver-color {{color4 | strip}} \
 --text-ver-color {{background | strip}}  --text-wrong-color {{background | strip}} --text-clear-color {{background | strip}} --text-caps-lock-color {{background | strip}}\
 --show-failed-attempts \
 --clock --indicator \
 --ignore-empty-password \
&& ~/scripts/wifi_autologin.sh