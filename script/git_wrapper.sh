#!/bin/sh

GIT_PATH=$(which git)
GIT_BAK="${GIT_PATH}.bak"
PROXY_CMD_PATH=$(which proxychains)

if [ "${UID}" != "0" ]; then
    echo "this script need run with root."
    exit 1
fi

if [ -x ${GIT_BAK} ]; then
    mv ${GIT_BAK} ${GIT_PATH}
    echo "change git cmd to origin"
else
    mv ${GIT_PATH} ${GIT_BAK}
    echo "#!/bin/sh" >> ${GIT_PATH}
    echo "" >> ${GIT_PATH}
    echo "${PROXY_CMD_PATH} ${GIT_BAK} \$*" >> ${GIT_PATH}
    chmod +x ${GIT_PATH}
    echo "git cmd wraped by proxy"
fi
