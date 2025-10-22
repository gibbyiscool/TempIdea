# Firmware Architecture

## Overview

TempIdea firmware is organized into modular components:

- **Drivers**: Hardware abstraction (display, touch, sensors)
- **Control**: Application logic (temperature control, PID)
- **UI**: LVGL integration and event handlers

## Module Structure

### Drivers (`src/drivers/`)

Hardware drivers for peripherals:

- `st7701.c` - Display driver
- `gt911.c` - Touch controller
- `emc2101.c` - Fan controller & temperature sensor

### Control (`src/control/`)

Application control logic:

- `temp_controller.c` - Temperature monitoring and fan control

### UI (`src/ui/`)

LVGL integration:

- `ui_init.c` - LVGL setup and initialization
- `generated/` - Auto-generated UI code from Cloud Editor
- `custom/` - Custom event handlers and callbacks

## Build System

CMake-based build using Pico SDK:

```bash
cmake -B build
make -C build
```

Output: `build/firmware/tempidea.uf2`

## Flashing

Hold BOOTSEL, connect USB, copy UF2 file to mounted drive.
