#!/bin/bash

function gitx() {
	if [[ -z $1 ]]; then
		echo "Usage: gitx -m [message]"
	elif [[ "$1" == "-m" ]]; then
		if [[ -n $2 ]]; then
				git add .
				git commit -m "$2"
				git push
		elif [[ -z $2 ]]; then
				read -p "Proceed with automated commit message? (y/n): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
				git add .
				git commit -m "Changes to code [automated commit]"
				git push
				
		fi
	fi
}




