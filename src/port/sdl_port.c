#include "sdl_port.h"
#include "lvgl/src/drivers/sdl/lv_sdl_window.h"
#include "lvgl/src/drivers/sdl/lv_sdl_mouse.h"

void sdl_port_init(uint16_t hor, uint16_t ver){
    lv_sdl_window_create(hor, ver);  /* creates LVGL display bound to SDL window */
    lv_sdl_mouse_create();           /* mouse acts as touch */
}
