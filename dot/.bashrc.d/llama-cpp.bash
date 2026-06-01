basedir=$(realpath -m $(dirname "${BASH_SOURCE[0]:-$0}"))
source "${basedir}/function.bash"

unset basedir

if [[ -e "$(type -p llama-cli)" ]]; then
    completion_file="llama-cpp"

    generate-bash-completion "$completion_file" "llama-cli --completion-bash"
    load-bash-completion -s "$completion_file"

    unset completion_file
fi
