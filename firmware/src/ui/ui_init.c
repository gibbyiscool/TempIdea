/**
 * @file ui_init.c
 * @brief LVGL UI initialization and integration
 */

#include "ui/ui_init.h"
#include "ui/generated/ui.h"
#include "lvgl/lvgl.h"

// Display buffer
static lv_disp_draw_buf_t draw_buf;
static lv_color_t buf1[480 * 10];
static lv_color_t buf2[480 * 10];

void ui_init(void) {
    // Initialize display buffer
    lv_disp_draw_buf_init(&draw_buf, buf1, buf2, 480 * 10);
    
    // Initialize display driver
    static lv_disp_drv_t disp_drv;
    lv_disp_drv_init(&disp_drv);
    disp_drv.draw_buf = &draw_buf;
    disp_drv.flush_cb = st7701_flush;
    disp_drv.hor_res = 480;
    disp_drv.ver_res = 480;
    lv_disp_drv_register(&disp_drv);
    
    // Initialize input device (touch)
    static lv_indev_drv_t indev_drv;
    lv_indev_drv_init(&indev_drv);
    indev_drv.type = LV_INDEV_TYPE_POINTER;
    indev_drv.read_cb = gt911_read;
    lv_indev_drv_register(&indev_drv);
    
    // Load generated UI
    ui_init_generated();
}
