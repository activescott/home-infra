# home-infra

The intent here is to maintain various apps and configurations that I run at home. Below is more detail about each.

# containers/home-assistant
This is my [Home Assistant](https://www.home-assistant.io) + [ZWave JS Server](https://github.com/zwave-js/zwave-js-server) implementation running on docker. See [containers/home-assistant/README.md](containers/home-assistant/README.md)

# containers/unifi-controller

A Ubiquity/Unifi Controller app setup running on docker. See [containers/unifi-controller/README.md](containers/unifi-controller/README.md)

# containers/cron

A generic setup for running cron jobs at home (e.g. for automated certificate renewal). See [containers/cron/README.md](containers/cron/README.md)


# TODO:
- home-assistant has a cert now, but still need to set it up to restart using home assistant automation
- docker hub won't support auto-build soon. So need to push containers from this repo in github actions
- Need to automate running `insmod /usr/local/modules/cp210x.ko` to get zwave container to start automatically. See ZWave notes in [containers/home-assistant/README.md](containers/home-assistant/README.md)
- Alerting needs setup if a cron job fails. Kibana container with alerting? stdin+logstash?
