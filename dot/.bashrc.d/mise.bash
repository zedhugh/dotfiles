basedir=$(realpath -m $(dirname "${BASH_SOURCE[0]:-$0}"))
source "${basedir}/function.bash"

unset basedir

if [[ -x $(type -p mise) ]]; then
    completion_cmd="mise completion --include-bash-completion-lib bash"
    generate-bash-completion mise "$completion_cmd"
    unset completion_cmd

    mise-activate() {
        eval "$(mise activate bash)"
    }

    mise-deactivate() {
        mise deactivate

        if [[ "$(type -p cd)" == "function" ]]; then
            unset cd
        fi

        local all_mise=$(compgen -v | grep -i '_mise')
        local mise
        for mise in $all_mise; do
            unset "$mise"
        done
    }
fi
