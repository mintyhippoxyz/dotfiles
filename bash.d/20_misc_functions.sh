#!/bin/bash

# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$_";
}

# Backup a directory
function backup() {
	mv $1 $1~
}

# Determine size of a file or total size of a directory
function fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh;
	else
		local arg=-sh;
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@";
	else
		du $arg .[^.]* *;
	fi;
}

# Create a data URL from a file
function dataurl() {
	local mimeType=$(file -b --mime-type "$1");
	if [[ $mimeType == text/* ]]; then
		mimeType="${mimeType};charset=utf-8";
	fi
	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
}

# Show eyeballs if previous command didn't exit with success
function eyeballs() {
	if [ $? != 0 ]; then
		printf "\033[01;31m( O_o) "
	fi
}

# Show all the names (CNs and SANs) listed in the SSL certificate for a given domain
function getcertnames() {
	if [ -z "${1}" ]; then
		echo "ERROR: No domain specified.";
		return 1;
	fi;
	local domain="${1}";
	echo "Testing ${domain}…";
	echo ""; # newline
	local tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
		| openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1);
	if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
		local certText=$(echo "${tmp}" \
			| openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
			no_serial, no_sigdump, no_signame, no_validity, no_version");
		echo "Common Name:";
		echo ""; # newline
		echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//";
		echo ""; # newline
		echo "Subject Alternative Name(s):";
		echo ""; # newline
		echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
			| sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2;
		return 0;
	else
		echo "ERROR: Certificate not found.";
		return 1;
	fi;
}

# Create an ebuild skeleton
eskel() {
	cp /usr/portage/skel.ebuild ./$1.ebuild
	cp /usr/portage/skel.ChangeLog ./ChangeLog
	cp /usr/portage/skel.metadata.xml ./metadata.xml
	LC_ALL=C sed -i -e "s/<PACKAGE_NAME>-<PACKAGE_VERSION>-<PACKAGE_RELEASE>/$1/g" \
		-e "s/DD MMM YYYY/$(date '+%d %b %Y')/g" \
		-e 's/YOUR_NAME/Matt Adams/g' \
		-e 's/YOUR_EMAIL/matt@rtvision.com/g' ChangeLog
	sed -i -e 's/>@rtvision.com/>matt@rtvision.com/g' metadata.xml
}

# Test the ebuild
etest() {
	ebuild $1 unpack && ebuild $1 compile && ebuild $1 install
}

# vim: ft=sh
