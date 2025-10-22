#include "lvgl.h"
#include "lv_conf.h"
#include "ports/sim/sdl_port.h"
#include "hal/hal.h"
#include "app/app.h"
#include "ui/TempIdea_gen.h"

int main(void){
    lv_init();
    sdl_port_init(480, 480);
    TempIdea_init_gen(NULL);
    hal_init();
    app_init();

    uint32_t last = 0;
    for(;;){
        lv_timer_handler();
        if (lv_tick_get() - last > 250) { app_update_ui(); last = lv_tick_get(); }
        lv_delay_ms(5);
    }
    return 0;
}
