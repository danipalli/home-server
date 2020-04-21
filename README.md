# Home Server Setup

> In this guide I will show you how to install Docker on the Raspberry Pi <br/>
> My Setup is: Raspberry Pi 3 B+ with Raspbian 10 buster light installed

---

## First Steps

- Flash the latest image of Raspbian to your SD Card and boot your Pi
- Login with user `pi` and password `raspberry`
- Change keyboard layout to `'at'` in the file `/etc/default/keyboard` and reboot
- Set a static ip in the file `/etc/dhcpcd.conf`

---

## Install Docker

> Currently the only approach to install Docker on Raspbian is to use the automated convenience script (see [Docs](https://docs.docker.com/engine/install/debian/#install-using-the-convenience-script)). NEVER run a script without viewing it's content.

1. Download the script: `curl -fsSL https://get.docker.com -o get-docker.sh`
2. Execute it: `sudo sh get-docker.sh`

---

## Install docker-compose

> The install instructions in the Docker Documentation are not working. Therefore I did some research and found the following solution.

Install pip

1. `sudo apt-get install python3-distutils`
2. `curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && sudo python3 get-pip.py`

Prepare Installation (see [Instructions](https://dev.to/rohansawant/installing-docker-and-docker-compose-on-the-raspberry-pi-in-5-simple-steps-3mgl))

1. `sudo apt-get install -y libffi-dev libssl-dev`
2. `sudo apt-get install -y python3 python3-pip`
3. `sudo apt-get remove python-configparser`

Install docker-compose

1. `sudo pip3 install docker-compose`

---

Now the Raspberry Pi is successfully set up with Docker and docker-compose.
For using the services like Pi-hole, continue by reading the Readme files in the corresponding folders.

If you specify `restart: unless-stopped` in the `docker-compose.yml` files, the service will start after a reboot of you Raspberry Pi. If you want to automate the manual startup and shutdown of all your services you can use my shell scripts. You will have to edit the scripts if you don't use my file structure.

My file structure:

```sh
/etc
    /home-server
        /gogs
            docker-compose.yml
        /pihole
            docker-compose.yml
```
