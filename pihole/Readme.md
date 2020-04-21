# How to use Pi-hole with Docker on the Raspberry Pi

I use Pi-hole as DNS and DHCP Server. You can use my `docker-compose.yml` file, but if you want to change something, read the [Pi-hole Docker Guide](https://github.com/pi-hole/docker-pi-hole) for specific information.

If you don't want to use DHCP, you should remove `network_mode: 'host'` line and add the port mappings to the `docker-compose.yml` file.

Now have fun with Pi-hole.
