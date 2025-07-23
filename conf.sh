#!/usr/bin/env bash

# Basic personal config loading

fatal() {
	echo '[fatal]' "$@" >&2
	exit 1
}

HOME_SOURCED_CONFIGS=(vimrc bashrc tmux.conf)

safe_link() {
    local src=$1
    local dest=$2

    if [[ -e "$dest" && ! -L "$dest" ]]; then
        echo "[backup] $dest exists, backing up to $dest.bak"
        mv "$dest" "$dest.bak"
    fi

    echo "[link] $dest -> $src"
    ln -nsf "$PWD/$src" "$dest"
}

for config in "${HOME_SOURCED_CONFIGS[@]}"; do
	eval "
	${config}_setup() {
		safe_link ${config} ~/.${config}	
	}
	"
done

keyd_setup() {
	# remaps capslock to esc and esc to capslock
	if ! command -v keyd >/dev/null 2>&1 ; then
		echo "installing keyd..."
		git clone --branch v2.5.0 --depth=1 https://github.com/rvaiya/keyd.git  || fatal 'failed to clone keyd git repo'
		cd keyd
		make || fatal 'failed to make'
		sudo make install || fatal 'failed to make install'
		cd ..
	fi
	sudo systemctl enable --now keyd
	sudo cp default.conf /etc/keyd/default.conf
	sudo keyd reload
}

get_all_setup_funcs() {
	declare -F | awk '{print $3}' | grep '_setup$'
}

main() {
	if [[ "$#" -eq 0 ]]; then
		echo "[usage] ./conf.sh <args>"
		echo "args can be list of different configs as seen in this current directory ($PWD)" 
		echo "OR simply the keyword 'all'"
	elif [[ "$1" == "all" ]]; then 
		mapfile -t setup_funcs < <(get_all_setup_funcs)
		for func in "${setup_funcs[@]}"; do
			echo "running $func"
			"$func"
		done
	else
		for arg in "$@"; do
			func="${arg}_setup"
			if declare -F "$func" > /dev/null; then 
				echo "running $func"
				"$func"
			else
				echo "[warning] no such config setup '$arg'"
			fi
		done
	fi	
}

main "$@"
