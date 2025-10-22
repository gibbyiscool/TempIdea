# TempIdea

**Intelligent Environmental Control & Display System**

TempIdea is an experimental DIY embedded system combining a touchscreen interface, active cooling control, and real-time environmental sensing. Built on the Waveshare RP2350B development board with a 2.8" IPS LCD and EMC2101 fan controller.

## Features

- 🌡️ Real-time temperature monitoring
- 💨 Automatic fan speed control
- 📱 Touch-enabled UI (480×480 IPS LCD)
- 🎨 LVGL-based interface designed with Cloud Editor
- ⚡ RP2350 dual-core architecture

## Hardware

- **MCU**: Waveshare RP2350B (RP2040 successor)
- **Display**: 2.8" IPS LCD (ST7701, 480×480)
- **Touch**: GT911 capacitive touch controller
- **Sensors**: EMC2101 fan controller + temperature sensor
- **Cooling**: Noctua NV-SPH1 with PWM control

## Quick Start

### Prerequisites

- Raspberry Pi Pico SDK
- CMake 3.13+
- ARM GCC toolchain
- LVGL Cloud Editor account

### Setup

```bash
# Clone repository
git clone <your-repo-url>
cd TempIdea

# Setup development environment
./scripts/setup_dev.sh

# Build firmware
./scripts/build.sh

# Flash to device
./scripts/flash.sh
```

### Development Workflow

1. **Design UI** in LVGL Cloud Editor
2. **Export** generated code to `lvgl-project/`
3. **Sync** code with `./scripts/sync_lvgl.sh`
4. **Build** firmware with `./scripts/build.sh`
5. **Flash** to device with `./scripts/flash.sh`

## Project Structure

```
TempIdea/
├── lvgl-project/        # LVGL Cloud Editor project
│   ├── project.xml
│   ├── globals.xml
│   └── screens/
├── firmware/            # RP2350 firmware
│   ├── src/
│   ├── include/
│   └── CMakeLists.txt
├── scripts/             # Build & deployment
└── docs/                # Documentation
```

## Documentation

- [Hardware Setup](docs/hardware/setup.md)
- [Firmware Architecture](docs/api/firmware.md)
- [LVGL Integration](docs/guides/lvgl-integration.md)

## License

MIT License - See LICENSE file for details

## Contributing

Contributions welcome! Please read CONTRIBUTING.md first.
