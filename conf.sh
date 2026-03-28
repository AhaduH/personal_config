#!/usr/bin/env bash

# Ngl I didn't know about gnu stow before this and just don't want to use nix
# Run in same dir as the config files cus I want to tab-complete the file/dir names as the args (lazy)

set -Eeu
trap 'echo "Error on line $LINENO: $BASH_COMMAND"' ERR
 
fatal() { 
    echo "[fatal]" "$@" >&2; exit 1;
}
 
[[ "$EUID" -eq 0 ]] && fatal "Do not run as root"
 
MY_CONFIGS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
 
# Maps config name → package(s) to install for that config (custom setup functions excluded, handle logic there)
declare -A PACKAGES=(
    [vim]="vim"
    [tmux.conf]="tmux"
    [nvim]="neovim"
    [ghostty]="ghostty"
    # Configs below are a bit out of scope, not a full desktop setup tool, still keep an idea of essential packages"
    #[hypr]="hyprland xdg-desktop-portal-hyprland hyprpolkitagent hyprpaper hyprshot hyprlock"
    #[waybar]="waybar btop pavucontrol"
    #[fuzzel]="fuzzel"
    #[mako]="mako libnotify"
)
 
# arch or debian based for pkg managers
HAS_PACMAN=0
HAS_APT=0
command -v pacman  >/dev/null 2>&1 && HAS_PACMAN=1
command -v apt-get >/dev/null 2>&1 && HAS_APT=1
 
install_pkg() {
    echo "[packages] installing: $*"
    if [[ "$HAS_PACMAN" -eq 1 ]]; then
        local official=() aur=()
        for pkg in "$@"; do
            if pacman -Si "$pkg" &>/dev/null; then 
                official+=("$pkg")
            else 
                aur+=("$pkg")
            fi
        done

        [[ "${#official[@]}" -gt 0 ]] && sudo pacman -S --needed --noconfirm "${official[@]}"
        if [[ "${#aur[@]}" -gt 0 ]]; then
            if   command -v yay  >/dev/null 2>&1; then 
                yay  -S --needed --noconfirm "${aur[@]}"
            elif command -v paru >/dev/null 2>&1; then 
                paru -S --needed --noconfirm "${aur[@]}"
            else 
                echo "[warning] Need AUR helper (yay / paru) for: ${aur[*]}" >&2
            fi
        fi
    elif [[ "$HAS_APT" -eq 1 ]]; then
        sudo apt-get install -y "$@"
    else
        echo "[warning] unknown distro (use git or distro pkg manager): $*" >&2
    fi
}
 
safe_link() {
    local src="$1" dest="$2"
    if [[ -e "$dest" && ! -L "$dest" ]]; then
        echo "[backup] $dest → $dest.bak"
        mv "$dest" "$dest.bak"
    fi

    echo "[linking] $dest → $src"
    if [[ "$dest" == /etc/* ]]; then 
        sudo ln -nsf "$src" "$dest"
    else                              
        ln -nsf "$src" "$dest"
    fi
}
 
run_setup() {
    local name="${1%/}" # strip trailing slash if needed (assuming it's a tab completed dir)
    local src="$MY_CONFIGS_DIR/$name"
 
    # trying -v (checks if element with that key is set)
    [[ -v PACKAGES[$name] ]] && {
        read -ra pkgs <<< "${PACKAGES[$name]}"
        install_pkg "${pkgs[@]}"
    }
 
    # just assume if no custom setup func -> file == $HOME DOTFILE, dir == $HOME/.config CONFIG DIR
    if declare -F "${name}_setup" >/dev/null; then
        "${name}_setup"
    elif [[ -f "$src" ]]; then
        safe_link "$src" "$HOME/.$name"
    elif [[ -d "$src" ]]; then
        mkdir -p "$HOME/.config"
        safe_link "$src" "$HOME/.config/$name"
    else
        echo "[warning] '$name' not found in $MY_CONFIGS_DIR and no ${name}_setup defined" >&2
        return 1
    fi
}
 
all_conf_names() {
    for path in "$MY_CONFIGS_DIR"/*; do
        local conf_name; conf_name="$(basename "$path")"
        [[ "$conf_name" == conf.sh || "$conf_name" == README.md ]] && continue
        echo "$conf_name"
    done
}
 
# Custom setup functions (specific behaviour more than $HOME DOTFILE or $HOME/.config CONFIG DIR) 
keyd_setup() {
    if ! command -v keyd >/dev/null 2>&1; then
        if [[ "$HAS_PACMAN" -eq 1 ]]; then
            sudo pacman -S --needed --noconfirm keyd
        elif [[ "$HAS_APT" -eq 1 ]]; then
            if apt-cache show keyd &>/dev/null; then
                sudo apt-get install -y keyd # Should work for Ubuntu 25.04 and up
            else
                # older Ubuntu/Debian or something else just build from source
                echo "[installing] keyd not in apt, building from source..."
                (
                    git clone --branch v2.5.0 --depth=1 \
                        https://github.com/rvaiya/keyd.git keyd_repo \
                        || fatal "failed to clone keyd"
                    cd keyd_repo
                    make || fatal "make failed"
                    sudo make install || fatal "make install failed"
                )
                rm -rf keyd_repo
            fi
        else
            fatal "start panicking bro"
        fi
    fi
 
    sudo systemctl enable --now keyd
    sudo mkdir -p /etc/keyd
    safe_link "$MY_CONFIGS_DIR/keyd" /etc/keyd/default.conf
    sudo keyd reload
}
 
main() {
    if [[ "$#" -eq 0 ]]; then
        echo "Usage: ./conf.sh <conf_name1> <conf_name2>... <conf_nameX> (<conf_name> from script dir)"
        echo "       ./conf.sh all (don't do this)"
        exit 0
    fi
    case "$1" in
        all) while IFS= read -r conf_name; do run_setup "$conf_name"; done < <(all_conf_names) ;;
        *) for arg in "$@"; do run_setup "$arg"; done ;;
    esac
}
 
main "$@"
