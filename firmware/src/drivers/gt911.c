/**
 * @file gt911.c
 * @brief GT911 capacitive touch controller driver
 */

#include "drivers/gt911.h"

void gt911_init(i2c_inst_t *i2c) {
    // TODO: Implement touch controller initialization
}

void gt911_read(lv_indev_drv_t *indev_drv, lv_indev_data_t *data) {
    // TODO: Implement touch reading
    data->state = LV_INDEV_STATE_RELEASED;
}
