/**
 * @file temp_controller.h
 * @brief Temperature controller header
 */

#ifndef TEMP_CONTROLLER_H
#define TEMP_CONTROLLER_H

#include <stdint.h>

void temp_controller_init(void);
void temp_controller_update(void);
float temp_controller_get_current_temp(void);
void temp_controller_set_target_temp(float temp);
uint8_t temp_controller_get_fan_speed(void);

#endif // TEMP_CONTROLLER_H
