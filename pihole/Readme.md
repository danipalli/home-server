# Docker Pi-hole

<p align="center">
<a href="https://pi-hole.net"><img src="https://pi-hole.github.io/graphics/Vortex/Vortex_with_text.png" width="150" height="255" alt="Pi-hole"></a><br/>
</p>

## Setup Instructions

1. Follow the instructions in the [pihole documentation](https://docs.pi-hole.net/guides/dns/unbound/) to setup `unbound` recursive resolver
3. Set up the web password in the `docker-compose.yaml`
4. Run `sudo ./home-server.sh --startup pihole` to start pi-hole


### Troubleshooting

- On Ubuntu and Fedora it is mandatory to deactivate
  [`systemd-resolve`](https://manpages.ubuntu.com/manpages/bionic/man8/systemd-resolved.service.8.html)
  which is configured by default to implement a caching DNS stub resolver.
  This will prevent pi-hole from listening on port `53`.
- It is mandatory to configure the same timezone for pi-hole and the underlying server.
  Otherwise, the signature validation for DNS responses fails and pi-hole rejects them with status *Bogus*.
  You can change the servers timezone with `sudo timedatectl set-timezone Europe/Vienna`.
- You need to set up an additional backup DNS server like `1.1.1.1` for your host server.
  Otherwise, your server can't resolve domains when pi-hole is down. Also initially pi-hole
  would not be able to start.

### Documentation

- https://docs.pi-hole.net/
- https://github.com/pi-hole/docker-pi-hole


