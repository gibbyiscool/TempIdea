# TempIdea Firmware Build Configuration

add_executable(tempidea
    src/main.c
    src/drivers/st7701.c
    src/drivers/gt911.c
    src/drivers/emc2101.c
    src/ui/ui_init.c
    src/control/temp_controller.c
    # Generated UI files will be added here
    src/ui/generated/ui.c
)

target_include_directories(tempidea PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/include
    ${CMAKE_CURRENT_LIST_DIR}/src/ui/generated
)

target_link_libraries(tempidea
    pico_stdlib
    hardware_i2c
    hardware_spi
    hardware_pwm
    hardware_gpio
)

# Enable USB output
pico_enable_stdio_usb(tempidea 1)
pico_enable_stdio_uart(tempidea 0)

# Create map/bin/hex/uf2 files
pico_add_extra_outputs(tempidea)

# Link LVGL library (add as submodule or external library)
# target_link_libraries(tempidea lvgl)
