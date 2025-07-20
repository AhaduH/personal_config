#!/usr/bin/env bash

# Basic personal config loading

fatal() {
	echo '[fatal]' "$@" >&2
	exit 1
}

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

keyd_setup() {
	# remaps capslock to esc and esc to capslock
	if [[ ! -d "keyd" ]]; then
		git clone https://github.com/rvaiya/keyd || fatal 'failed to clone keyd git repo'
	fi
	cd keyd
	make && sudo make install
	cd ..
	sudo systemctl enable --now keyd
	sudo cp default.conf /etc/keyd/default.conf
	sudo keyd reload
}

vimrc_setup() {
	safe_link vimrc ~/.vimrc
}
	
get_all_setup_funcs() {
	declare -F | awk '{print $3}' | grep '_setup$'
}

main() {
	if [[ "$1" == "all" ]]; then 
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
