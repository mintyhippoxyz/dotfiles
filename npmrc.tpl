#!/bin/bash

[[ -z ${NPM_EMAIL+x} ]] && read -p "Your Email (NPM): " NPM_EMAIL
[[ -z ${NPM_USER+x} ]] && read -p "Username (NPM): " NPM_USER

cat <<EOF
email = $NPM_EMAIL
username = $NPM_USER
init.author.email = $NPM_EMAIL
init.author.name = $NPM_USER
init.author.url = http://
loglevel = warn
viewer = browser
EOF

# vim: ft=sh
