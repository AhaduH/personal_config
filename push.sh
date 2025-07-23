#!/usr/bin/env bash

git status

read -rp "commit changes? (y/n): " answer
if [[ "${answer,,}" != "y" ]]; then 
	echo "exiting..."
	exit 1
fi

read -rp "enter commit mesage: " msg

git add .
git commit -m "$msg"
git push
