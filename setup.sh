#!/bin/bash -l
set -e

tags="$1"

if [ -z $tags ]; then
	tags="all"
fi

ansible-playbook -i hosts dotfiles.yml --ask-become-pass --tags $tags
