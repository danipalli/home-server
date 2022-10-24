# Ubuntu Server Setup

<p align="center">
<a href="https://pi-hole.net"><img src="https://assets.ubuntu.com/v1/ff6a9a38-ubuntu-logo-2022.svg" width="500" height="255" alt="Pi-hole"></a><br/>
</p>

### Setup Static IP

1. #### Disable `cloud-init` if present<br/>

   The easiest way to know if `cloud-init` is present or not is to check if there is a package with that name.

   Run the following command to check:

    ```sh
    apt-cache pkgnames | grep cloud-init
    ```
   
   If you get an output, `cloud-init` is installed. To disable it, create
   a file called

   ```
   sudo touch /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
   ```
   
   And add the following line to it

   ```
   network: {config: disabled}
   ```
   
   Reboot now before setting up the static ip.


2. #### Netplan configuration

   Go to the `/etc/netplan` directory.
   There might be one or more `.yaml` configuration files. You can choose to delete
   those files if you don't need their configurations.<br/><br/>

   Edit one of those files or create a new configuration file like below, but be
   aware that you can not define the same network interface like twice

   ```
   sudo touch /etc/netplan/99-config.yaml
   ```

   To set up a static ip add the following content to your `.yaml` configuration file:
   ```yaml
   network:
     version: 2
     ethernets:
       eth0:
         dhcp4: no
         addresses:
           - 192.168.0.250/24
         nameservers:
           addresses: [127.0.0.1]
         routes:
           - to: default
             via: 192.168.0.1
   ```

   To apply the settings, run `sudo netplan apply`.


### Define automated tasks

Run `sudo crontab -e` to define automated tasks that should be run as root.
