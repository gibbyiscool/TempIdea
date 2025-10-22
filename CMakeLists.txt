cmake_minimum_required(VERSION 3.13)

# Include Pico SDK
include(firmware/pico_sdk_import.cmake)

project(TempIdea C CXX ASM)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

# Initialize Pico SDK
pico_sdk_init()

# Add firmware subdirectory
add_subdirectory(firmware)
