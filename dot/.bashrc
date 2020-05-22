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

export PATH="/usr/lib/ccache/bin${PATH:+:}$PATH"
export CCACHE_DIR="/var/cache/ccache"
export GPG_TTY=$(tty)

# export PATH="~/.local/bin${PATH:+:}$PATH"

alias ll="ls -l"
alias la="ls -a"
alias lh="ls -lh"
alias lha="ls -lha"
