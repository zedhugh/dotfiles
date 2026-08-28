basedir=$(realpath $(dirname "${BASH_SOURCE[0]:-$0}"))
source "${basedir}/function.bash"

unset basedir

if [[ -x "$(type -p uv)" ]]; then
    generate-bash-completion uv "uv generate-shell-completion bash"
fi

if [[ -x "$(type -p uvx)" ]]; then
    generate-bash-completion uvx "uvx --generate-shell-completion bash"
fi
