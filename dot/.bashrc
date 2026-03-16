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

export PATH="${HOME}/.local/bin${PATH:+:}$PATH"

alias ll="ls -l"
alias la="ls -a"
alias lh="ls -lh"
alias lha="ls -lha"

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

# bash completion error
if [[ -n $(type -t _comp__split_longopt) ]] && [[ -z $(type -t _split_longopt) ]]; then
    alias _split_longopt="_comp__split_longopt"
fi

for _ in ${HOME}/.bashrc.d/*; do
    if [[ $_ == *.@(bash|sh) && -r $_ ]]; then
        source "$_"
    fi
done

if [[ -n "$(type -t mise-activate)" ]]; then
    mise-activate
fi
