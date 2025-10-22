# Hardware Setup Guide

## Components

1. Waveshare RP2350B Development Board
2. 2.8" IPS LCD Display (ST7701)
3. Adafruit EMC2101 Fan Controller
4. Noctua NV-SPH1 PWM Hub
5. 5V PWM Fan(s)

## Wiring

### I2C Connections

| Device | SDA | SCL | Address |
|--------|-----|-----|---------|
| EMC2101 | GPIO 4 | GPIO 5 | 0x4C |
| GT911 Touch | GPIO 4 | GPIO 5 | 0x5D |

### Display Interface

The display connects directly to the RP2350B via the board's RGB interface pins.

### Fan Connections

EMC2101 → Noctua NV-SPH1 → Fan(s)

## Assembly

1. Mount display to RP2350B header
2. Connect EMC2101 to I2C pins
3. Wire fan controller to Noctua hub
4. Connect power (USB-C or Li-ion)

## Testing

```bash
# Build and flash test firmware
cd firmware
./scripts/build.sh
./scripts/flash.sh
```
