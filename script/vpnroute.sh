#!/bin/sh

if [[ "$1" != "set" ]] && [[ "$1" != "unset" ]]; then
    echo "Usage: $0 <set|unset>"
    exit 1;
fi

if [[ "$UID" != "0" ]]; then
    echo "$0: you must run this as root"
    exit 1
fi

cd $(dirname $0)

ADAPTER=$(./vpncmd localhost /client /cmd accountlist | grep -e '网络适配器\|Adapter' | cut -d '|' -f 2)
ADAPTER=$(echo $ADAPTER | awk '{ print tolower($0) }')
DEV=vpn_$ADAPTER

echo $DEV

if [[ "$1" == "set" ]]; then
    dhcpcd -k $DEV
    dhcpcd $DEV
    GW=$(ip route show | grep "default.*$DEV" | awk '{print $3}')
    sleep 1
    ip route del default dev $DEV
    ip route add 192.168.0.0/24 via $GW
fi

if [[ "$1" == "unset" ]]; then
    dhcpcd -k $DEV
fi
