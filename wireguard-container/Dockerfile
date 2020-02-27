FROM ubuntu:18.04

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y software-properties-common debconf-utils iptables curl iputils-ping \
    && add-apt-repository -y ppa:wireguard/wireguard \
    && apt-get update \
    && echo resolvconf resolvconf/linkify-resolvconf boolean false | debconf-set-selections \
    && apt-get install -y iproute2 wireguard-tools curl resolvconf \
    && apt-get clean

COPY wg1.conf /etc/wireguard/
COPY startup.sh /
CMD ["/startup.sh"]
