/**
 * @file temp_controller.c
 * @brief Temperature monitoring and fan control logic
 */

#include "control/temp_controller.h"
#include "drivers/emc2101.h"
#include <stdio.h>

static float current_temp = 0.0f;
static float target_temp = 25.0f;
static uint8_t fan_speed = 0;

void temp_controller_init(void) {
    printf("Temperature controller initialized\n");
    emc2101_set_fan_speed(0);
}

void temp_controller_update(void) {
    // Read current temperature
    current_temp = emc2101_read_temp();
    
    // Simple proportional control
    float error = current_temp - target_temp;
    
    if (error > 2.0f) {
        fan_speed = 100;  // Full speed
    } else if (error > 0.5f) {
        fan_speed = (uint8_t)(error * 25.0f);  // Proportional
    } else {
        fan_speed = 0;  // Off
    }
    
    emc2101_set_fan_speed(fan_speed);
}

float temp_controller_get_current_temp(void) {
    return current_temp;
}

void temp_controller_set_target_temp(float temp) {
    target_temp = temp;
}

uint8_t temp_controller_get_fan_speed(void) {
    return fan_speed;
}
