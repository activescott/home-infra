# containers/unifi-controller

My Ubiquity/Unifi Network Controller app setup.

This is designed specifically for running on qnap's "Container Station" app. However, there probably isn't anything all that unique to qnap about this.

Specifically using this container: https://github.com/linuxserver/docker-unifi-controller which is also on dockerhub at https://registry.hub.docker.com/r/linuxserver/unifi-controller

Note from the docker details on linuxserver:

> The webui is at https://ip:8443, setup with the first run wizard.
> For Unifi to adopt other devices, e.g. an Access Point, it is required to change the inform ip address. Because Unifi runs inside Docker by default it uses an ip address not accessable by other devices. To change this go to Settings > Controller > Controller Settings and set the Controller Hostname/IP to an ip address accessable by other devices.

I found it easiest to just set `network_mode: "host"` on the service in docker-compose and it found everything just fine.
