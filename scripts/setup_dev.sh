#!/bin/bash

################################################################################
# Setup Development Environment
################################################################################

set -e

echo "🛠️  Setting up TempIdea development environment..."

# Update package list
echo "  📦 Updating packages..."
sudo apt-get update -qq

# Install build essentials
echo "  🔧 Installing build tools..."
sudo apt-get install -y -qq \
    cmake \
    gcc-arm-none-eabi \
    libnewlib-arm-none-eabi \
    build-essential \
    libstdc++-arm-none-eabi-newlib \
    git

# Clone Pico SDK if not present
if [ ! -d "pico-sdk" ]; then
    echo "  📥 Cloning Pico SDK..."
    git clone --depth 1 https://github.com/raspberrypi/pico-sdk.git
    cd pico-sdk
    git submodule update --init
    cd ..
fi

# Set environment variable
export PICO_SDK_PATH="$(pwd)/pico-sdk"
echo "export PICO_SDK_PATH=$(pwd)/pico-sdk" >> ~/.bashrc

echo ""
echo "✅ Development environment ready!"
echo ""
echo "Environment variables:"
echo "  PICO_SDK_PATH=$PICO_SDK_PATH"
echo ""
echo "Next steps:"
echo "  1. Design UI in LVGL Cloud Editor"
echo "  2. Export and download generated code"
echo "  3. Copy to lvgl-project/ directory"
echo "  4. Run: ./scripts/sync_lvgl.sh"
echo "  5. Run: ./scripts/build.sh"
