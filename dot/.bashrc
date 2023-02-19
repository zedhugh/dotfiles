# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi


# Put your fun stuff here.
HISTCONTROL=ignoreboth
#export PATH="~/.local/bin:/usr/lib/distcc/bin:${PATH}"

# export PATH="~/.local/bin/:/usr/lib/ccache/bin${PATH:+:}$PATH"
# export CCACHE_DIR="/var/cache/ccache"
export GPG_TTY=$(tty)

export PATH="~/.local/bin${PATH:+:}$PATH"

alias ll="ls -l"
alias la="ls -a"
alias lh="ls -lh"
alias lha="ls -lha"


set-proxy() {
    export http_proxy=http://127.0.0.1:8118
    export https_proxy=https://127.0.0.1:8118
}

unset-proxy() {
    unset http_proxy
    unset https_proxy
}

set-git-proxy() {
    prefix_cmd=""
    flag="--global"
    if [[ "$1" == "-s" ]]; then
        prefix_cmd="sudo"
        flag="--system"
    fi

    $prefix_cmd git config $flag http.proxy http://127.0.0.1:8118
    $prefix_cmd git config $flag http.sslVerify false
}

unset-git-proxy() {
    prefix_cmd=""
    flag="--global"
    if [[ "$1" == "-s" ]]; then
        prefix_cmd="sudo"
        flag="--system"
    fi

    $prefix_cmd git config $flag --unset http.proxy
    $prefix_cmd git config $flag --unset http.sslVerify
}

set-npm-proxy() {
    npm config set proxy http://127.0.0.1:8118
    npm config set https-proxy http://127.0.0.1:8118
}

unset-npm-proxy() {
    npm config delete proxy
    npm config delete https-proxy
}

if [[ "${TERM}" != "tmux-256color" ]]; then
    tmux
fi

alias pip='function _pip() {
      if [ $1 == "search" ]; then
         pip_search "$2";
      else pip "$@";
      fi;
};_pip'

# pnpm
export PNPM_HOME="/home/zedhugh/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end
# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/bash/__tabtab.bash ] && . ~/.config/tabtab/bash/__tabtab.bash || true
