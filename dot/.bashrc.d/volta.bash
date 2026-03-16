basedir=$(realpath -m $(dirname "${BASH_SOURCE[0]:-$0}"))
source "${basedir}/function.bash"

unset basedir

export VOLTA_HOME="${HOME}/.volta"

if [[ -x $(type -p volta) || -x "${VOLTA_HOME}/bin/volta" ]]; then
    generate-bash-completion volta "volta completions bash"

    volta-activate() {
        add-to-path "${VOLTA_HOME}/bin"

        # enable pnpm support
        # export VOLTA_FEATURE_PNPM=1
    }

    volta-deactivate() {
        local bin_dir="${VOLTA_HOME}/bin"
        remove-from-path "$bin_dir"
        unhash-command-in-dirs "$bin_dir"
    }
fi


