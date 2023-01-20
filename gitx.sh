#!/bin/bash

function gitx() {
	if [[ -z $1 ]]; then
		git add --all
		git commit -m "Add latest changes"
		git push
	elif [[ "$1" == "-m" ]]; then
		if [[ -n $2 ]]; then
			git add --all
			git commit -m "$2"
			git push
		elif [[ -z $2 ]]; then
			echo -n "Proceed with default commit message? (y/n): " 
			read confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
			git add --all
			git commit -m "Add latest changes"
			git push
				
		fi
	fi
}




