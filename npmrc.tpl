#!/bin/bash

[[ -z ${NPM_EMAIL+x} ]] && read -p "(npm) Email: " NPM_EMAIL
[[ -z ${NPM_USER+x} ]] && read -p "(npm) Username: " NPM_USER

cat <<EOF
loglevel = warn
viewer = browser
email = $NPM_EMAIL
username = $NPM_USER
EOF
