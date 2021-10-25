# containers/home-assistant:

This is my [Home Assistant](https://www.home-assistant.io) implementation.

Currently running this via QNAP Container Station using a plain docker-compose setup.
The entire QNAP Container Station configuration is a direct copy/paste from `containers/home-assitant/home-assitant-docker-compose.yml` which consists of container for Home Assitant and another for ZWave JS Server.
This includes saving all data from both the Home Assitant container (via docker-compose volumes) and the ZWave JS Server container to the host on a backed up drive.

## Home Assistant https Certificate

The [contaienrs/cron](../cron/README.md) container runs holds a cron script to auto-renew certs using letsencrypt. Home Assistant is configured to use those certs by (1) mapping the letsencrypt volume to the container and configuring Home Assitant's `http` integration (bundled) in configuration.yaml as described at https://www.home-assistant.io/integrations/http

## Z-Wave & ZWave JS Server

For Z-Wave support, I use a Nortek Security & Control Zigbee & Z-Wave USB Controller (model number HUSBZB-1) plugged into the USB port on the QNAP and have the USB port mapped to a [ZWave JS Zwavejs2Mqtt](https://github.com/zwave-js/zwavejs2mqtt) container. Then Home Assistant connects to Zwavejs2Mqtt Server via a websocket to have a gateway to Z-Wave.

A couple interesting notes setting up Z-Wave:

- Originally I created a ZWave JS Server container defined at `containers/home-assitant/zwave-js-server.Dockerfile` and [published it](https://hub.docker.com/repository/docker/activescott/zwave-js-server). However, I later discovered https://github.com/zwave-js/zwavejs2mqtt and am now using that. For detail see it's configuration in `home-assitant-docker-compose.yml` in this repo.
- The Z-Wave USB Stick only works in USB 2.0 ports - it will _not_ work in the USB 3.0 ports. No idea why but someone mentioned that in a thread and it was a problem for me too!
- In the docker-compose file you can see where I map the Z-Wave USB Stick device from the host QNAP (`/dev/ttyUSB0`) to `/dev/zwave` inside of the container.
- To get the USB Stick to work, use `insmod /usr/local/modules/cp210x.ko` (no output appears, but `/dev/ttyUSB0` appears when doing `ls -l /dev/tty*`).
  - I have this set up in the QNAP host as part of some autorun script that QNAP supports. **TODO:** Document where that file is!

### Publishing activescott/zwave-js-server Docker Hub

The `activescott/zwave-js-server` container is on dockerhub at https://hub.docker.com/repository/docker/activescott/zwave-js-server
A manual build to build the container from the Dockerfile source in the `main` branch in this repo can be published by clicking on "Trigger" button for the `latest` dockerhub tag at https://hub.docker.com/repository/docker/activescott/zwave-js-server/builds

Update `containers/home-assitant/zwave-js-server.Dockerfile` and use a git tag on the commit with a tag that meets the regex `^zwave-js-server-([0-9.]+)` and dockerhub should detect the git tag and automatically publish an image from that commit with the tag `release-<version>`. For example the git tag `zwave-js-server-1.0.0` should result in a docker tag `release-1.0.0` and a valid image reference from docker-compose of `activescott/zwave-js-server:release-1.0.0`.

## Home Assistant Hardware / Integrations

### Nortek QuickStick Combo HUSBZB-1

For Z-Wave and Zigbee support. Plugged into a QNAP on the host and device mapped into the ZWave JS Server container and the home assistant container (for zigbee).

### GoControl Linear GD00Z-4 Z-Wave Smart Garage Door Controller/with tilt sensor

~~Easy to hook up and works like a champ. It is picky if the power goes out. You MUST follow the instructions to "resync" it by using another control (push button or remote) to raise the garage up and than down again completely. Then it works perfect.~~ This worked at first fine, but after about two months it stopped controlling the garage. I found a fair bit of similar experiences on the web.

I have since switched to a Zooz ZEN17 Universal Relay to control the garage (see below).

#### Zooz Z-Wave Plus 700 Series Universal Relay ZEN17 with 2 NO & NC Relays (20A, 10A)

I use this to control the garage door now. I do not _yet_ have it hooked up for the full "garage" integration in Home Assistant so it looks more like a switch than a garage door at the moment.

### Ubiquity UniFi

Mostly for presence protection. I have POE cameras on it and it freaked me out that I could turn off the POE for those devices in Home Assistant (and Home Kit !) so I disabled the switches, but the device presence detection is all there.

### Certificate Expiry

For anyone a operating production SaaS application at scale (such as [Smartsheet 😉](https://www.smartsheet.com/)), you must empathize with my paranoia about expiring certificates. So I love having my various personal home infrastructure certificates' "expires in" front and center on my Home Assistant dashboard and alerting set up as it gets close to expiring 🤓

### HomeKit/HASS Bridge

Home Assistant's whole world seems to appear in the Apple "Home" app on my phone and Apple TV as if it was meant to be. Home Assistant is _so_ good though I'm not sure why to bother with Home Kit.

### Apple TV

I turned this on but I'm not entirely clear what it does or what to use it for 🤷‍♂️ I think I uninstalled it.

### Integration Roadmap / Plans

#### Honeywell Vista 20P Integration

I have a Honeywell "Vista 20P" connected to a variety of security sensors at parameter and inside the home and garage. Specifically the chip on the board says `WA20P-9.12`.
There is an [AlarmDecoder Home Assistant Integration](https://www.home-assistant.io/integrations/alarmdecoder/) which looks very nice! It requires an [AlarmDecoder hardware/bridge](https://www.alarmdecoder.com/wiki/index.php/Getting_Started) and the "Network Appliance" board that works via a Raspberry Pi seems to basically route the alarm panel's features to local ethernet which HA can talk to over ethernet. Ordered, not yet integrated into Home Assistant.

#### GE Z-Wave Dimmer Switch for Fans

Rated for fans and I have a POC set up to a fan to ensure it worked, but not yet paired with Home Asssistant and fully installed for the fan in my server room (fan just stays at full speed and seems mostly necessary this time of year anyway).

#### Zooz 700 Series Z-Wave Plus S2 On / Off Wall Switch ZEN76

Planned for internal lighting.

#### Zooz 700 Series Z-Wave Plus S2 Dimmer Switch ZEN77

Planned for internal lighting.

## Templates Notes

[Jinja Templates](https://jinja.palletsprojects.com/en/latest/templates/) are hard to read and filters are weak. Here's a couple notes:

Iterating through a sequence of objects and mapping them to a format:

An example of people and their presence:

    {% for pp in expand('group.family_presence') %}{{ state_attr(pp.entity_id, 'friendly_name') }} is {{ states(pp.entity_id) }}
    {% endfor %}

An example for sensors:

    {% for s in expand('group.perimeter_sensors') %}{{ state_attr(s.entity_id, 'friendly_name') }} is {{ states(s.entity_id) }}
    {% endfor %}

Here is another template using "filters" that converts a group's list of items into a list of entity_id strings. I'm not sure what to do with this yet, it doesn't work in a lovelace card:

    {{ expand('group.common_area_lights') | map(attribute='entity_id') | list() }}

Here is another one using full expressions but doesn't seem to work right for a lovelace card:

    {% for light in expand('group.common_area_lights') %}{{ "\n  - {}".format(light.entity_id) }}{% endfor %}

### One thing I want to do is expand groups into a yaml array of entity IDs, but can't figure out how to do it:
And it was [confirmed on the forum that this isn't supported](https://community.home-assistant.io/t/how-do-expand-groups-for-lovelace-entities-card-with-jinja/349892) 🙁


## Groups

Groups work good for conditions and checking a single state, but are hard to work with to understand what happened in a trigger. For example, `group.perimeter_sensors` is a great way to check if every perimeter sensor is closed/off. However, when using it as a trigger, you cant tell in the automation's event trigger data _which_ sensor triggered it (only that the group state changed).