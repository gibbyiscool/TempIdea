#include "lvgl.h"
#include "ports/rp2350/rp2350_port.h"
#include "hal/hal.h"
#include "app/app.h"
#include "ui/TempIdea_gen.h"

int main(void){
    lv_init();
    rp2350_port_init();      /* TODO: real hardware init */
    TempIdea_init_gen(NULL);
    hal_init();              /* swap to real HAL later */
    app_init();

    for(;;){
        lv_timer_handler();
        app_update_ui();
        lv_delay_ms(5);
    }
    return 0;
}
