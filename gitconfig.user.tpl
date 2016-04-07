#!/bin/bash
# vim: ft=sh

[[ -z ${GIT_NAME+x} ]] && read -p "(git) Name: " GIT_NAME
[[ -z ${GIT_EMAIL+x} ]] && read -p "(git) Email: " GIT_EMAIL
[[ -z ${GITHUB_USER+x} ]] && read -p "(git) GitHub Username: " GITHUB_USER

cat <<EOF
# vim: ft=gitconfig
[user]
	name = $GIT_NAME
	email = $GIT_EMAIL

[github]
	user = $GITHUB_USER

EOF
