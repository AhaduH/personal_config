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

git_branch_check(){
    local branch=$(git branch --show-current 2>/dev/null) || return
    [[ -n "$branch" ]] && printf " (%s%s%s)" "$YELLOW" "$branch" "$RESET"
}

prompt_helper() {
    local exit_code=$?

    EXIT_PREV=""
    [[ "$exit_code" -ne 0 ]] && EXIT_PREV="${RED}${exit_code}${RESET} "

    PS1="${EXIT_PREV}${GREEN}\u@\h${RESET} ${BLUE}\W${RESET}$(git_branch_check) \$ "
}

PROMPT_COMMAND=prompt_helper

alias ls='ls --color=auto'
alias grep='grep --color=auto'
