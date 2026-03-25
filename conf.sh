#!/usr/bin/env bash

# Basic personal config loading

set -Eeuo pipefail

trap 'echo "Error on line $LINENO: $BASH_COMMAND"' ERR

fatal() {
	echo '[fatal]' "$@" >&2
	exit 1
}

if [[ "$EUID" -eq 0 ]]; then
    fatal "Do not run this script as root"
fi

DOTFILES=(vimrc bashrc tmux.conf)
ON_ARCH=0
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    if [[ "$ID" == arch ]]; then
        ON_ARCH=1       
    fi
fi


safe_link() {
    local src=$1
    local dest=$2

    if [[ -e "$dest" && ! -L "$dest" ]]; then
        echo "[backup] $dest exists, backing up to $dest.bak"
        mv "$dest" "$dest.bak"
    fi

    echo "[linking] $dest -> $src"
    if [[ "$dest" == /etc/* ]]; then
        sudo ln -nsf "$PWD/$src" "$dest"
    else
        ln -nsf "$PWD/$src" "$dest"
    fi
}

for config in "${DOTFILES[@]}"; do
	eval "
	${config}_setup() {
		safe_link "${config}" "${HOME}/.${config}"	
	}
	"
done

keyd_setup() {
	# remaps capslock to esc and esc to capslock
	if ! command -v keyd >/dev/null 2>&1 ; then
        if [[ "$ON_ARCH" -eq 1 ]]; then
            sudo pacman -S keyd
        else
            echo "installing keyd..."
            git clone --branch v2.5.0 --depth=1 https://github.com/rvaiya/keyd.git keyd_repo  || fatal 'failed to clone keyd git repo'
            cd keyd_repo
            make || fatal 'failed to make'
            sudo make install || fatal 'failed to make install'
            cd ..
        fi
	fi
	sudo systemctl enable --now keyd
    safe_link keyd /etc/keyd/default.conf
	sudo keyd reload
}

nvim_setup() {
    mkdir -p $HOME/.config
    safe_link nvim $HOME/.config/nvim 
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
