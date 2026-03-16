basedir=$(realpath -m $(dirname "${BASH_SOURCE[0]:-$0}"))
source "${basedir}/function.bash"

unset basedir

if [[ -d "${HOME}/.cargo/bin" ]]; then
    add-to-path "${HOME}/.cargo/bin"
fi

if [[ -e "${HOME}/.cargo/env" ]]; then
    . "${HOME}/.cargo/env"
fi

if [[ -x "$(type -p rustup)" ]]; then
    generate-bash-completion rustup "rustup completions bash cargo"
    generate-bash-completion cargo "rustup completions bash cargo"
fi
