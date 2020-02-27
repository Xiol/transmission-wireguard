Transmission + Wireguard
========================

This is mainly for my own benefit, don't expect best practice here.

Requires Wireguard to be installed on the host machine. This is not for container zealots.

Usage
-----

* Build the Wireguard container:

```shell
$ cd wireguard-container
$ docker build --pull -t wireguard:latest .
```

* Edit environment variables in `docker-compose.yml`
* Bring everything up - `docker-compose up -d`

Credits
-------

* https://nbsoftsolutions.com/blog/routing-select-docker-containers-through-wireguard-vpn
* https://github.com/cmulk/wireguard-docker
