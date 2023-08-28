# ESPHome

I'm using ESPHome and an [Olimex ESP32-PoE](https://www.olimex.com/Products/IoT/ESP32/ESP32-POE/open-source-hardware) to connect to wired window/door sensors.

## References

- ESP32-POE board on platform.org (ESPHome is based on platform.org toolkit): https://docs.platformio.org/en/latest/boards/espressif32/esp32-poe.html#board-espressif32-esp32-poe

## Notes

### Olimex ESP32-PoE Notes
- Use use `esp32-poe` ID for board option in ESPHome or platform.org stuff
- To configured ethernet use the ESPHome [ethernet component](https://esphome.io/components/ethernet)
  - Info on thread at https://github.com/esphome/issues/issues/53
  - `type: LAN8720` worked for me.

### ESPHome Stuff
- To configure a output switch: https://esphome.io/components/switch/gpio
- To setup an input: https://esphome.io/guides/getting_started_command_line#adding-a-binary-sensor

#### Running ESPHome

Run the esphome command to configure/re-upload yaml config to esphome-installed boards. The first time ESPHome's firmware needs installed via USB/Serial. Once it's installed, it will handle updates "OTA" (over ethernet/wifi).

- Install [`esphome` command from homebrew](https://formulae.brew.sh/formula/esphome#default)
- Run `esphome dashboard ./config` (where `./config` is config dir for esphome in current dir - it puts yaml files there) to program esphome devices over wifi/ethernet.

## Example Working Config on Olimex ESP32-POE:

```yaml
esphome:
  name: adu

esp32:
  board: esp32-poe
  framework:
    type: arduino

# Enable logging
logger:

# Enable Home Assistant API
api:
  encryption:
    key: !secret api_encryption_key

ota:
  password: !secret ota_password

ethernet:
  type: LAN8720
  mdc_pin: GPIO23
  mdio_pin: GPIO18
  clk_mode: GPIO17_OUT
  phy_addr: 0
  power_pin: GPIO12
  # without `manual_ip` it uses DHCP

# use a pin to listen to a door/window sensor:
# see https://esphome.io/components/binary_sensor/gpio
# and https://esphome.io/guides/configuration-types#pin-schema
binary_sensor:
  - platform: gpio
    name: "Test Window"
    pin:
      number: 2
      inverted: true
      mode:
        input: true
        pullup: true
```
