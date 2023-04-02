# home-assistant on kubernetes

This is my [Home Assistant](https://www.home-assistant.io) implementation.

Currently running this via a TrueNAS setup using plain kubernetes (TrueNAS includes k3s).

I configure a deployment for Home Assitant and another for ZWave JS Server.

This includes saving all data from both the Home Assitant container (via kubernetes volumes) and the ZWave JS Server container to the host on a backed up drive.

## Home Assistant https Certificate

The [contaienrs/cron](../cron/README.md) app runs holds a cron script to auto-renew certs using letsencrypt. Home Assistant is configured to use those certs by (1) mapping the letsencrypt volume to the container and configuring Home Assistant's `http` integration (bundled) in configuration.yaml as described at https://www.home-assistant.io/integrations/http

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
