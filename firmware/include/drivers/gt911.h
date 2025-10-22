/**
 * @file gt911.h
 * @brief GT911 touch controller header
 */

#ifndef GT911_H
#define GT911_H

#include "hardware/i2c.h"
#include "lvgl/lvgl.h"

void gt911_init(i2c_inst_t *i2c);
void gt911_read(lv_indev_drv_t *indev_drv, lv_indev_data_t *data);

#endif // GT911_H
