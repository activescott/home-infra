# home-assistant on kubernetes

This is my [Home Assistant](https://www.home-assistant.io) implementation.

Currently running this via a TrueNAS setup using plain kubernetes (TrueNAS includes k3s).

I configure a deployment for Home Assitant and another for ZWave JS Server.

This includes saving all data from both the Home Assitant container (via kubernetes volumes) and the ZWave JS Server container to the host on a backed up drive.

## Home Assistant https Certificate

The [contaienrs/cron](../cron/README.md) app runs holds a cron script to auto-renew certs using letsencrypt. Home Assistant is configured to use those certs by (1) mapping the letsencrypt volume to the container and configuring Home Assistant's `http` integration (bundled) in configuration.yaml as described at https://www.home-assistant.io/integrations/http

## Z-Wave & ZWave JS Server

For Z-Wave support, I use a Nortek Security & Control Zigbee & Z-Wave USB Controller (model number HUSBZB-1) plugged into the USB port on the host computer and have the USB port mapped to a [ZWave JS Zwavejs2Mqtt](https://github.com/zwave-js/zwavejs2mqtt) container. Then Home Assistant connects to Zwavejs2Mqtt Server via a websocket to have a gateway to Z-Wave.

A couple interesting notes setting up Z-Wave:

- I use a ZWave JS Server container from https://github.com/zwave-js/zwavejs2mqtt set up as its own StatefulSet+Service in Kubernetes.
- All config data for zwavejs2mqtt is stored on a host directory mapped via a Kubernetes volume.
- The Z-Wave USB Stick only works in USB 2.0 ports - it will _not_ work in the USB 3.0 ports. No idea why but someone mentioned that in a thread and it was a problem for me too!
- In the StatefulSet file you can see where I map the Z-Wave USB Stick device from the host (`/dev/serial/by-id/usb-Silicon_Labs_HubZ_Smart_Home_Controller_C1301B96-if00-port0`) to `/dev/zwave` inside of the container.

## Home Assistant Hardware / Integrations

### Nortek QuickStick Combo HUSBZB-1

A couple interesting notes setting up Z-Wave:

NOTE: The Z-Wave USB Stick only works in USB 2.0 ports - it will _not_ work in the USB 3.0 ports. No idea why but someone mentioned that in a thread and it was a problem for me too!

To figure out where this gets mounted, I plugged it in and ran `sudo dmesg | grep usb` after plugging in the USB stick and as you can see below it mounts both `/dev/ttyUSB0` and `/dev/ttyUSB1`. One of these is the Z-Wave support and one is Zigbee.

```sh
$ sudo dmesg | grep usb
...
[317856.990929] usb 1-8.4: new full-speed USB device number 7 using xhci_hcd
[317857.093545] usb 1-8.4: New USB device found, idVendor=10c4, idProduct=8a2a, bcdDevice= 1.00
[317857.093776] usb 1-8.4: New USB device strings: Mfr=1, Product=2, SerialNumber=5
[317857.093999] usb 1-8.4: Product: HubZ Smart Home Controller
[317857.094213] usb 1-8.4: Manufacturer: Silicon Labs
[317857.094423] usb 1-8.4: SerialNumber: C1301B96
[317857.115257] usbcore: registered new interface driver usbserial_generic
[317857.115968] usbserial: USB Serial support registered for generic
[317857.118331] usbcore: registered new interface driver cp210x
[317857.119466] usbserial: USB Serial support registered for cp210x
[317857.122640] usb 1-8.4: cp210x converter now attached to ttyUSB0
[317857.124673] usb 1-8.4: cp210x converter now attached to ttyUSB1
```

### Garage Door

I am currently using a [Zooz Z-Wave Plus 700 Series Universal Relay ZEN17 with 2 NO & NC Relays (20A, 10A)](https://www.thesmartesthouse.com/products/zooz-z-wave-plus-700-series-universal-relay-zen17-with-2-no-nc-relays-20a-10a) to control the garage and a [Ecolink Z-Wave Plus Garage Door Tilt Sensor TILTZWAVE2.5-ECO](https://www.thesmartesthouse.com/products/ecolink-z-wave-plus-garage-door-tilt-sensor-tiltzwave2-5-eco). I glue the two together into a proper "Garage Device/Integration" in Home Assistant with a so-called ["Cover Template"](https://www.home-assistant.io/integrations/cover.template/#garage-door) that is defined in `/config-home-assistant/configuration.yaml`.

**OLD**: I originally had a **GoControl Linear GD00Z-4 Z-Wave Smart Garage Door Controller/with tilt sensor**. It was easy to hook up and worked like a champ at first. However, it was picky if the power goes out. You MUST follow the instructions to "resync" it by using another control (push button or remote) to raise the garage up and than down again completely.~~ This worked at first fine, but after about two months it stopped controlling the garage. I found a fair bit of similar experiences on the web.

### Ubiquity UniFi

Mostly for presence protection. I have POE cameras on it and it freaked me out that I could turn off the POE for those devices in Home Assistant (and Home Kit !) so I disabled the switches, but the device presence detection is all there.

### Certificate Expiry

For anyone a operating production SaaS application at scale, you must empathize with my paranoia about expiring certificates. So I love having my various personal home infrastructure certificates' "expires in" front and center on my Home Assistant dashboard and alerting set up as it gets close to expiring 🤓

### HomeKit/HASS Bridge

Home Assistant's whole world seems to appear in the Apple "Home" app on my phone and Apple TV as if it was meant to be. Home Assistant is _so_ good though I'm not sure why to bother with Home Kit.

### Apple TV

I turned this on but I'm not entirely clear what it does or what to use it for 🤷‍♂️ I think I uninstalled it.

### Integration Roadmap / Plans

#### Honeywell Vista 20P Integration

I have a Honeywell "Vista 20P" connected to a variety of security sensors at parameter and inside the home and garage. Specifically the chip on the board says `WA20P-9.12`. I coonnect that to a [AlarmDecoder hardware/bridge](https://www.alarmdecoder.com/wiki/index.php/Getting_Started) on a Raspberry Pi (sitting inside the alaram box). This allows browser and API-based control of the Alarm Panel. The [AlarmDecoder Home Assistant Integration](https://www.home-assistant.io/integrations/alarmdecoder/) is then a plugin for Home Assistant that fully controls alarm and all the sensors in Home Assistant. This gives fullly supported motion sensors and premeter sensors for the entire house to Home Assistant and those csensors are cheaper than Z-Wave or Zigbee on eBay. Works perfect for a couple years now. The Honeywell is a bit wonky to program (a series of number sequenceis, but its not hard, just tedius one-time setup).

#### Zooz 700 Series Z-Wave Plus S2 On / Off Wall Switch ZEN76

I have several for internal lighting. Work great for a couple years.

#### Zooz 700 Series Z-Wave Plus S2 Dimmer Switch ZEN77

I have one for internal lighting. Work great for a couple years.

#### GE Z-Wave Dimmer Switch for Fans

The GE is rated for fans and I have had it in Home Asssistant and automated in my server room. I no longer use that setup, but it worked perfectly fine.

## Notes on Using Home Assistant

### Backup

To backup Home Assistant it stores critical information in a folder named `[your config]/.storage`. NOTE the `.` in `.storage`. By default backup programs usually skip .-prefixed folder names. This means you loose users/auth information using the default Auth Provider and it seems integrations you installed in the UI.

They recently provided a backup integration at https://www.home-assistant.io/integrations/backup/ that should make this more resilient if configured.

### Templates Notes

[Jinja Templates](https://jinja.palletsprojects.com/en/latest/templates/) are hard to read and filters are weak. Here's a couple notes:

Iterating through a sequence of objects and mapping them to a format:

An example of people and their presence:

    {% for pp in expand('group.family_presence') %}{{ state_attr(pp.entity_id, 'friendly_name') }} is {{ states(pp.entity_id) }}
    {% endfor %}

An example for sensors:

    {% for s in expand('group.perimeter_sensors') %}{{ state_attr(s.entity_id, 'friendly_name') }} is {{ states(s.entity_id) }}
    {% endfor %}

Here is another template using "filters" that converts a group's list of items into a list of entity_id strings. I'm not sure what to do with this yet, it doesn't work in a lovelace card:

    {{ expand('light.common_area_lights') | map(attribute='entity_id') | list() }}

### Expand Groups into Entities in a Lovelace Dashboard Card

Although [Home Assistant doesn't support expanding groups into a Lovelace Dashboard card](https://community.home-assistant.io/t/how-do-expand-groups-for-lovelace-entities-card-with-jinja/349892) (🙁), you can use the [third-party auto-entities Lovelace Plugin](https://github.com/thomasloven/lovelace-auto-entities) to do that.

#### Using Auto-Entities

In the UI you can now add a new type of card that appears as **Custom: Auto Entities** and simply chose a group as a filter. In the YAML it looks like the below for the group named `light.common_area_lights`:

```yaml
type: custom:auto-entities
card:
  type: entities
  title: Common Area Lights
  state_color: true
filter:
  include:
    - group: light.common_area_lights
  exclude: []
sort:
  method: friendly_name
```

#### Installing Lovelace Plugin:

Copy the js file (and any other files may require) to any subdirectory in `<home assistant config>/www/` (for example I have auto-entities at [`config-home-assistant/www/plugins/auto-entities/auto-entities.js`](config-home-assistant/www/plugins/auto-entities/auto-entities.js)). Then put a path to the plugin's file(s) using the Home Assistant UI by doing the following:

1. Go to "Configuration" The gear symbol near the bottom of the sidebar.
2. Select "Lovelace Dashboard".
3. Select the "Resources" tab (enable "Advanced Mode" under your user's profile if you don't see it) and add the resource as sipmly the path to the plugin's file(s) (e.g. for my auto-entities plugin, this is simply **URL** `/local/plugins/auto-entities/auto-entities.js` and **Resource Type** of _JavaScript Module_).

### Groups

Groups work good for conditions and checking a single state, but are hard to work with to understand what happened in a trigger. For example, `group.perimeter_sensors` is a great way to check if every perimeter sensor is closed/off. However, when using it as a trigger, you cant tell in the automation's event trigger data _which_ sensor triggered it (only that the group state changed).
