#include "lvgl.h"
#include "port/sdl_port.h"
#include "hal/hal.h"
#include "ui/TempIdea_gen.h"
#include "ui/TempIdea.h"

static void tick_cb(void *arg){ (void)arg; lv_tick_inc(1); hal_tick_1ms(); }

int main(void){
    lv_init();
    sdl_port_init(480, 480);
    TempIdea_init_gen(NULL);
    hal_init();

    lv_timer_create(tick_cb, 1, NULL);

    uint32_t last = 0;
    for(;;){
        lv_timer_handler();
        if (lv_tick_get() - last > 250){
            hal_telemetry_t t; hal_read(&t);
            ui_update_values(t.temp_c, t.duty);
            last = lv_tick_get();
        }
        lv_delay_ms(5);
    }
    return 0;
}
