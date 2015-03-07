#!/bin/bash

# Get the short symbolic ref.
# If HEAD isnt a symbolic ref, get the short SHA for the latest commit
# Otherwise, just give up.
git_current_branch() {
	local branchName='';
	branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
	git rev-parse --short HEAD 2> /dev/null || \
	'(unknown)')";
	echo $branchName
}

# Build the git prompt
git_prompt() {
	local s='';
	# Check if the current directory is in a Git repository.
	if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then
		# check if the current directory is in .git before running git checks
		if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then
			# Ensure the index is up to date.
			git update-index --really-refresh -q &>/dev/null;
			# Check for uncommitted changes in the index.
			if ! $(git diff --quiet --ignore-submodules --cached); then
				s+='+';
			fi;
			# Check for unstaged changes.
			if ! $(git diff-files --quiet --ignore-submodules --); then
				s+='!';
				fi;
			# Check for untracked files.
			if [ -n "$(git ls-files --others --exclude-standard)" ]; then
				s+='?';
			fi;
			# Check for stashed files.
			if $(git rev-parse --verify refs/stash &>/dev/null); then
				s+='$';
			fi;
		fi;
		[ -n "${s}" ] && s=" [${s}]";
		echo -e "${1}$(git_current_branch)${blue}${s}";
	else
		return;
	fi;
}
