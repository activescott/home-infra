# home-infra

The intent here is to maintain various apps and configurations that I run at home. Below is more detail about each.

# containers/home-assistant:
This is my Home Assistant and ZWave JS Server implementation. 
Currently running this via QNAP Container Station using a plain docker/docker-compose setup.
It consists of a docker-compose file with a Home Assitant container and a ZWave JS container.

ZWave JS Server doesn't provide its own container so I have one defined at `containers/home-assitant/zwave-js-server.Dockerfile` and published at https://hub.docker.com/repository/docker/activescott/zwave-js-server
