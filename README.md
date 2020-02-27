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
* Connect to Transmission on port 9091 or proxy using nginx (from *gasp* the host). To proxy to yourdomain.com/transmission/:

(Actually, this is probably wrong. The aliases clearly won't work with the containers, but probably work for me because I still have a now inactive copy of Transmission installed on the host machine. Guess that's never getting removed because it's working. 🤷)

```
http {
    upstream transmission {
        server 127.0.0.1:9091;
    }

    server {
        # whatever

        location ^~ /transmission {
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $http_host;
            proxy_set_header X-NginX-Proxy true;
            proxy_http_version 1.1;
            proxy_set_header Connection "";
            proxy_pass_header X-Transmission-Session-Id;
            add_header   Front-End-Https   on;

            location /transmission/rpc {
                proxy_pass http://transmission;
            }

            location /transmission/web/ {
                proxy_pass http://transmission;
            }

            location /transmission/upload {
                proxy_pass http://transmission;
            }

            location /transmission/web/style/ {
                alias /usr/share/transmission/web/style/;
            }

            location /transmission/web/javascript/ {
                alias /usr/share/transmission/web/javascript/;
            }

            location /transmission/web/images/ {
                alias /usr/share/transmission/web/images/;
            }

            location /transmission/ {
                return 301 https://$server_name/transmission/web;
            }
        }

        # whatever
    }
}
```

Credits
-------

* https://nbsoftsolutions.com/blog/routing-select-docker-containers-through-wireguard-vpn
* https://github.com/cmulk/wireguard-docker
