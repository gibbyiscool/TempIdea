/**
 * @file st7701.h
 * @brief ST7701 display driver header
 */

#ifndef ST7701_H
#define ST7701_H

#include "lvgl/lvgl.h"

void st7701_init(void);
void st7701_flush(lv_disp_drv_t *disp_drv, const lv_area_t *area, lv_color_t *color_p);

#endif // ST7701_H
