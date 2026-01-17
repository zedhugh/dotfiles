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

PROXY_SHELL_FILE="$(realpath ~/.bash_proxy.sh)"
if [[ -e $PROXY_SHELL_FILE ]] ; then
    . $PROXY_SHELL_FILE
fi

if [[ "$TERM" == "linux" ]]; then
    PS1="(tty) $PS1"
elif [[ "$TERM" == "fbterm" ]]; then
    PS1="(fbterm) $PS1"
fi

# use fbterm to show CJK charactor in tty
if [[ "$TERM" == "linux" ]] && [[ -x $(type -p fbterm) ]]; then
    fbterm
elif [[ "${TERM}" != "tmux-256color" ]] && [[ -z "${TERM_PROGRAM}" ]] && [[ -x $(type -p tmux) ]]; then
    tmux
fi

alias pip='function _pip() {
      if [ $1 == "search" ]; then
         pip_search "$2";
      else pip "$@";
      fi;
};_pip'

# pnpm
export PNPM_HOME="$(realpath ~/.local/share/pnpm)"
export PATH="$PNPM_HOME:$PATH"
# pnpm end
# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/bash/__tabtab.bash ] && . ~/.config/tabtab/bash/__tabtab.bash || true

clean-pnpm-node() {
    if [[ -d "$PNPM_HOME" ]]; then
        rm -f "$PNPM_HOME/nodejs_current"
        rm -f "$PNPM_HOME/node"
        rm -f "$PNPM_HOME/npm"
        rm -f "$PNPM_HOME/npx"
    fi
}
