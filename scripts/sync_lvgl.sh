#!/bin/bash

################################################################################
# Sync LVGL Cloud Editor Generated Code to Firmware
################################################################################

set -e

LVGL_ROOT="lvgl-project"
FIRMWARE_UI="firmware/src/ui/generated"

echo "🔄 Syncing LVGL generated code..."

# Check if LVGL project exists
if [ ! -d "$LVGL_ROOT" ]; then
    echo "❌ Error: LVGL project directory not found"
    exit 1
fi

# Create firmware UI directory if it doesn't exist
mkdir -p "$FIRMWARE_UI"

# Copy generated C/H files
echo "  📋 Copying generated source files..."

# Copy examples_gen.c/h if they exist
if [ -f "$LVGL_ROOT/examples_gen.c" ]; then
    cp "$LVGL_ROOT/examples_gen.c" "$FIRMWARE_UI/ui.c"
    echo "    ✓ ui.c"
fi

if [ -f "$LVGL_ROOT/examples_gen.h" ]; then
    cp "$LVGL_ROOT/examples_gen.h" "$FIRMWARE_UI/ui.h"
    echo "    ✓ ui.h"
fi

# Copy examples.c/h (manual code)
if [ -f "$LVGL_ROOT/examples.c" ]; then
    cp "$LVGL_ROOT/examples.c" "$FIRMWARE_UI/ui_custom.c"
    echo "    ✓ ui_custom.c"
fi

if [ -f "$LVGL_ROOT/examples.h" ]; then
    cp "$LVGL_ROOT/examples.h" "$FIRMWARE_UI/ui_custom.h"
    echo "    ✓ ui_custom.h"
fi

# Copy assets if needed
if [ -d "$LVGL_ROOT/images" ]; then
    mkdir -p "$FIRMWARE_UI/assets"
    cp -r "$LVGL_ROOT/images"/* "$FIRMWARE_UI/assets/" 2>/dev/null || true
    echo "    ✓ Image assets"
fi

echo "✅ Sync complete!"
echo ""
echo "Next steps:"
echo "  1. Build firmware: ./scripts/build.sh"
echo "  2. Flash to device: ./scripts/flash.sh"
