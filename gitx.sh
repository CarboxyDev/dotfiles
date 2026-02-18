function gitx() {
	if [[ -z $1 ]]; then
		git add --all && git commit -m "Add latest changes" && git push || return 1
		echo "Committed and pushed."
	elif [[ "$1" == "-m" ]]; then
		if [[ -n $2 ]]; then
			git add --all && git commit -m "$2" && git push || return 1
		else
			echo -n "Proceed with default commit message? (y/n): "
			read confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || return 1
			git add --all && git commit -m "Add latest changes" && git push || return 1
		fi
		echo "Committed and pushed."
	fi
}




