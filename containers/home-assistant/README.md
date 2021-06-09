# containers/home-assistant:

This is my [Home Assistant](https://www.home-assistant.io) implementation.

Currently running this via QNAP Container Station using a plain docker-compose setup.
The entire QNAP Container Station configuration is a direct copy/paste from `containers/home-assitant/home-assitant-docker-compose.yml` which consists of container for Home Assitant and another for ZWave JS Server.
This includes saving all data from both the Home Assitant container (via docker-compose volumes) and the ZWave JS Server container to the host on a backed up drive.

## Z-Wave & ZWave JS Server

For Z-Wave support, I use a Nortek Security & Control Zigbee & Z-Wave USB Controller (model number HUSBZB-1) plugged into the USB port on the QNAP and have the USB port mapped to a [ZWave JS Server](https://github.com/zwave-js/zwave-js-server) container. Then Home Assistant connects to ZWave JS Server via a websocket to have a gateway to Z-Wave.

A couple interesting notes setting up Z-Wave:

- ZWave JS Server doesn't provide its own container so I have one defined at `containers/home-assitant/zwave-js-server.Dockerfile` and published at https://hub.docker.com/repository/docker/activescott/zwave-js-server
  - It is published by dockerhub listening for pushes in the github repo and building automatically.
- The Z-Wave USB Stick only works in USB 2.0 ports - it will _not_ work in the USB 3.0 ports. No idea why but someone mentioned that in a thread and it was a problem for me too!
- In the docker-compose file you can see where I map the Z-Wave USB Stick device from the host QNAP (`/dev/ttyUSB0`) to `/dev/zwave` inside of the container.
- To get the USB Stick to work, use `insmod /usr/local/modules/cp210x.ko` (no output appears, but `/dev/ttyUSB0` appears when doing `ls -l /dev/tty*`)

### Publishing activescott/zwave-js-server Docker Hub

The `activescott/zwave-js-server` container is on dockerhub at https://hub.docker.com/repository/docker/activescott/zwave-js-server
A manual build to build the container from the Dockerfile source  in the `main` branch in this repo can be published by clicking on "Trigger" button for the `latest` dockerhub tag at https://hub.docker.com/repository/docker/activescott/zwave-js-server/builds

Update `containers/home-assitant/zwave-js-server.Dockerfile` and use a git tag on the commit with a tag that meets the regex `^zwave-js-server-([0-9.]+)` and dockerhub should detect the git tag and automatically publish an image from that commit with the tag `release-<version>`. For example the git tag `zwave-js-server-1.0.0` should result in a docker tag `release-1.0.0` and a valid image reference from docker-compose of `activescott/zwave-js-server:release-1.0.0`.
