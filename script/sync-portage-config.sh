#!/bin/sh

check_root_permissioin() {
    local SCRIPT_NAME=$(basename $0)

    if [[ "$UID" != "0" ]]; then
        echo "${SCRIPT_NAME}: must run this as root"
        exit 1
    fi
}

sync_portage_config() {
    local SCRIPT_DIR=$(dirname $0)
    local CONFIG_DIR=$(realpath "${SCRIPT_DIR}/../gentoo_portage")
    local DEST_DIR="/etc/portage"

    # 常用配置文件列表
    local CONFIG_FILES=(
        # 仓库配置
        "binrepos.conf"
        "repos.conf"

        # 构建配置
        "make.conf"
        "package.accept_keywords"
        "package.license"
        "package.mask"
        "package.unmask"
        "package.use"

        # 单独的 env 配置
        "env"
        "package.env"

        "sets"
        "patches"
    )
    for CONFIG_FILE in "${CONFIG_FILES[@]}"; do
        local SOURCE_FILE="${CONFIG_DIR}/${CONFIG_FILE}"
        local TARGET_FILE="${DEST_DIR}/${CONFIG_FILE}"

        # 清理原先的配置
        rm -rf $TARGET_FILE

        # 将新的配置通过软链接链接到目标目录
        if [[ -e $SOURCE_FILE ]]; then
            echo "link: ${SOURCE_FILE} -> ${TARGET_FILE}"
            ln -s $SOURCE_FILE $TARGET_FILE
        fi
    done
}

check_root_permissioin
sync_portage_config
