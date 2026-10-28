#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Colors
RESET='\[\033[0m\]'
RED='\[\033[1;31m\]'
GREEN='\[\033[1;32m\]'
YELLOW='\[\033[1;33m\]'
BLUE='\[\033[1;34m\]'

export EDITOR=nvim
export VISUAL=nvim

export HISTSIZE=50000
export HISTFILESIZE=100000
export HISTTIMEFORMAT="%F %T - "
shopt -s histappend
# maybe don't need this (testing)
HISTCONTROL=ignoredups

shopt -s globstar

git_branch_check(){
    local branch=$(git branch --show-current 2>/dev/null) || return
    [[ -n "$branch" ]] && printf " (%s%s%s)" "$YELLOW" "$branch" "$RESET"
}

prompt_helper() {
    local exit_code=$?
    # share history across long-lived tmux shells without losing $?.
    history -a
    history -n

    EXIT_PREV=""
    [[ "$exit_code" -ne 0 ]] && EXIT_PREV="${RED}${exit_code}${RESET} "

    PS1="${EXIT_PREV}${GREEN}\u@\h${RESET} ${BLUE}\W${RESET}$(git_branch_check) \$ "
}

PROMPT_COMMAND=prompt_helper

# basic command aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -al'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# bash-completion package
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi

# fzf shell integration (through path)
if command -v fzf >/dev/null 2>&1; then
    if fzf_bash=$(fzf --bash 2>/dev/null); then
        eval "$fzf_bash"
    fi
    unset fzf_bash
fi

# personal scripts
case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

# project discovery directories
export PROJ_ROOTS="$HOME/dev:$HOME/Documents"
