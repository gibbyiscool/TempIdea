#!/bin/bash

################################################################################
# Flash TempIdea Firmware to RP2350
################################################################################

set -e

UF2_FILE="build/firmware/tempidea.uf2"

if [ ! -f "$UF2_FILE" ]; then
    echo "❌ Error: Firmware not built. Run ./scripts/build.sh first"
    exit 1
fi

echo "🔌 Flashing TempIdea firmware..."

# Look for RP2350 in bootloader mode
RPI_MOUNT=$(ls /media/$USER/RPI-RP2* 2>/dev/null | head -n 1)

if [ -z "$RPI_MOUNT" ]; then
    echo "❌ Error: RP2350 not found in BOOTSEL mode"
    echo ""
    echo "To enter BOOTSEL mode:"
    echo "  1. Hold the BOOTSEL button"
    echo "  2. Connect USB"
    echo "  3. Release BOOTSEL"
    exit 1
fi

echo "  📍 Found device at: $RPI_MOUNT"
echo "  📤 Copying firmware..."

cp "$UF2_FILE" "$RPI_MOUNT/"

echo ""
echo "✅ Firmware flashed successfully!"
echo "   Device will reboot automatically"
