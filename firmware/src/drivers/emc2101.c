/**
 * @file emc2101.c
 * @brief EMC2101 fan controller and temperature sensor driver
 */

#include "drivers/emc2101.h"

#define EMC2101_ADDR 0x4C
#define TEMP_REG 0x00
#define FAN_CONFIG_REG 0x4A

static i2c_inst_t *i2c_port;

void emc2101_init(i2c_inst_t *i2c) {
    i2c_port = i2c;
    // TODO: Configure EMC2101 registers
}

float emc2101_read_temp(void) {
    uint8_t temp_data;
    i2c_read_blocking(i2c_port, EMC2101_ADDR, &temp_data, 1, false);
    return (float)temp_data;
}

void emc2101_set_fan_speed(uint8_t speed_percent) {
    // TODO: Implement PWM fan control
}

uint16_t emc2101_read_fan_rpm(void) {
    // TODO: Read tachometer value
    return 0;
}
