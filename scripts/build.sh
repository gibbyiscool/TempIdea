#!/bin/bash

################################################################################
# Build TempIdea Firmware
################################################################################

set -e

BUILD_DIR="build"

echo "🔨 Building TempIdea firmware..."

# Create build directory
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Run CMake
echo "  📝 Configuring with CMake..."
cmake ..

# Build
echo "  🏗️  Compiling..."
make -j$(nproc)

echo ""
echo "✅ Build complete!"
echo "   Output: build/firmware/tempidea.uf2"
echo ""
echo "To flash:"
echo "  1. Hold BOOTSEL and connect RP2350"
echo "  2. Run: ./scripts/flash.sh"
