proxy_ip="192.168.0.104"
proxy_http_port="20172"
# SOCKS_PROXY="socks5://${PROXY_IP}:20170"

_proxy_config_validate() {
    if [[ -z "$proxy_ip" && -z "$proxy_http_port" ]]; then
        echo "error: proxy_ip and proxy_http_port is not set" >&2
        return 1
    fi
    if [[ -z "$proxy_ip" ]]; then
        echo "error: proxy_id is not set"
        return 1
    fi
    if [[ -z "$proxy_http_port" ]]; then
        echo "error: proxy_http_port is not set"
        return 1
    fi

    if ! [[ "$proxy_http_port" =~ ^[0-9]+$ ]] || ((proxy_http_port < 1 || proxy_http_port > 65535)); then
        echo "error: proxy_http_port is invalid: $proxy_http_port" >&2
        return 1
    fi

    if command -v nc >/dev/null 2>&1; then
        if ! nc -z -w2 "$proxy_ip" "$proxy_http_port" 2>/dev/null; then
            echo "error: proxy $proxy_ip:$proxy_http_port is not reachable" >&2
            return 1
        fi
    fi

    return 0
}

set-shell-proxy() {
    _proxy_config_validate || return 1

    local http_proxy_url="http://${proxy_ip}:${proxy_http_port}"

    export http_proxy="$http_proxy_url"
    export https_proxy="$http_proxy_url"
}

unset-shell-proxy() {
    unset http_proxy
    unset https_proxy
}

set-git-proxy() {
    _proxy_config_validate || return 1

    local prefix_cmd=""
    local flag="--global"
    if [[ "$1" == "-s" ]]; then
        prefix_cmd="sudo"
        flag="--system"
    elif [[ "$1" == "-l" ]]; then
        flag="--local"
    fi

    local http_proxy_url="http://${proxy_ip}:${proxy_http_port}"

    $prefix_cmd git config $flag http.proxy $http_proxy_url
    $prefix_cmd git config $flag http.sslVerify false
}

unset-git-proxy() {
    local prefix_cmd=""
    local flag="--global"
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
    _proxy_config_validate || return 1

    local http_proxy_url="http://${proxy_ip}:${proxy_http_port}"

    npm config set proxy $http_proxy_url
    npm config set https-proxy $http_proxy_url
}

unset-npm-proxy() {
    npm config delete proxy
    npm config delete https-proxy
}
