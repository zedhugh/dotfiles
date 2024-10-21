HTTP_PROXY="http://192.168.1.13:20172"
SOCKS_PROXY="socks5://192.168.1.13:20170"

set-shell-proxy() {
    export http_proxy="$HTTP_PROXY"
    export https_proxy="$HTTP_PROXY"
}

unset-shell-proxy() {
    unset http_proxy
    unset https_proxy
}

set-git-proxy() {
    prefix_cmd=""
    flag="--global"
    if [[ "$1" == "-s" ]]; then
        prefix_cmd="sudo"
        flag="--system"
    elif [[ "$1" == "-l" ]]; then
        flag="--local"
    fi

    $prefix_cmd git config $flag http.proxy $HTTP_PROXY
    $prefix_cmd git config $flag http.sslVerify false
}

unset-git-proxy() {
    prefix_cmd=""
    flag="--global"
    if [[ "$1" == "-s" ]]; then
        prefix_cmd="sudo"
        flag="--system"
    elif [[ "$1" == "-l" ]]; then
        flag="--local"
    fi

    $prefix_cmd git config $flag --unset http.proxy
    $prefix_cmd git config $flag --unset http.sslVerify
}

set-npm-proxy() {
    npm config set proxy $HTTP_PROXY
    npm config set https-proxy $HTTP_PROXY
}

unset-npm-proxy() {
    npm config delete proxy
    npm config delete https-proxy
}
