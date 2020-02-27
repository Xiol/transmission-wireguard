#!/bin/bash
set -euo pipefail

sed -i "s/__VPN_ADDR__/$VPN_ADDRESS/" /etc/wireguard/wg1.conf
sed -i "s/__PRIVATE_KEY__/$PRIVATE_KEY/" /etc/wireguard/wg1.conf
sed -i "s/__PUBLIC_KEY__/$REMOTE_PUBLIC_KEY/" /etc/wireguard/wg1.conf
sed -i "s/__ENDPOINT__/$ENDPOINT/" /etc/wireguard/wg1.conf
sed -i "s/__PORT__/$PORT/" /etc/wireguard/wg1.conf
VPN_CHECK_INTERVAL=${VPN_CHECK_INTERVAL:-10}

wg-quick up wg1

VPN_IP=$(grep -Po 'Endpoint\s=\s\K[^:]*' /etc/wireguard/wg1.conf)

function finish {
    echo "$(date): Shutting down vpn"
    wg-quick down wg1
}

function has_vpn_ip {
    curl --silent --show-error --retry 10 --fail https://icanhazip.com | grep $VPN_IP
}

trap finish TERM INT

while [[ has_vpn_ip ]]; do
    sleep $VPN_CHECK_INTERVAL;
done

echo "$(date): VPN IP address not detected"