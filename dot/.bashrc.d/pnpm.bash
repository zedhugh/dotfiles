basedir=$(realpath -m $(dirname "${BASH_SOURCE[0]:-$0}"))
source "${basedir}/function.bash"

unset basedir

export PNPM_HOME="${HOME}/.local/share/pnpm"
add-to-path -s $PNPM_HOME

if [[ -x "$(type -p pnpm)" ]]; then
    generate-bash-completion pnpm "pnpm completion bash"
fi

if [[ -x "$(type -p npm)" ]]; then
    generate-bash-completion npm "npm completion"
fi

clean-pnpm-node() {
    if [[ -d "$PNPM_HOME" ]]; then
        rm -f "$[PNPM_HOME]/nodejs_current"
        rm -f "${PNPM_HOME}/node"
        rm -f "${PNPM_HOME}/npm"
        rm -f "${PNPM_HOME}/npx"
    fi
}
