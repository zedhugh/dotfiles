if [[ -x $(type -p pip_search) ]]; then
    function _pip() {
        if [[ "$1" == "search" ]]; then
            pip_search "$2"
        else
            pip "$@"
        fi
    }
    alias pip=_pip
fi
