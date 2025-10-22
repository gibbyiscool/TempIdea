/**
 * @file st7701.c
 * @brief ST7701 display driver for 480x480 IPS LCD
 */

#include "drivers/st7701.h"

void st7701_init(void) {
    // TODO: Implement display initialization
}

void st7701_flush(lv_disp_drv_t *disp_drv, const lv_area_t *area, lv_color_t *color_p) {
    // TODO: Implement display flush callback
    lv_disp_flush_ready(disp_drv);
}
