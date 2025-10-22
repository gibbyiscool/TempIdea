/**
 * @file emc2101.h
 * @brief EMC2101 fan controller header
 */

#ifndef EMC2101_H
#define EMC2101_H

#include "hardware/i2c.h"
#include <stdint.h>

void emc2101_init(i2c_inst_t *i2c);
float emc2101_read_temp(void);
void emc2101_set_fan_speed(uint8_t speed_percent);
uint16_t emc2101_read_fan_rpm(void);

#endif // EMC2101_H
