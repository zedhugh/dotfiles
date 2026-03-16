basedir=$(realpath -m $(dirname "${BASH_SOURCE[0]:-$0}"))
source "${basedir}/function.bash"

unset basedir

if [[ -e "$(type -p fnm)" ]]; then
    generate-bash-completion fnm "fnm completions --shell bash"

    fnm-activate() {
        hash -r
        eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"
        export FNM_NODE_DIST_MIRROR="https://npmmirror.com/mirrors/node"

        __fnmcd() {
            \cd "$@" || return $?
            unhash-command-in-dirs "$FNM_MULTISHELL_PATH"/bin
            __fnm_use_if_file_found
        }
    }

    fnm-deactivate() {
        if [[ "$(type -t cd)" == "alias" ]]; then
            unalias cd
        fi

        if [[ -z "$FNM_MULTISHELL_PATH" ]]; then
            return 0
        fi

        local fnm_multishell="$(dirname "$FNM_MULTISHELL_PATH")"
        local -a envs=$(compgen -v | grep '^FNM_')
        local -a all_tmp_dir=("$fnm_multishell"/*)
        local -a bin_paths=("$fnm_multishell"/*/bin)

        remove-from-path "${bin_paths[@]}"
        unhash-command-in-dirs "${bin_paths[@]}"
        rm -rf "${all_tmp_dir[@]}"

        local var
        for var in $envs; do
            unset "$var"
        done
    }
fi
