#include "app.h"
#include "lvgl.h"
#include "../hal/hal.h"

/* These labels exist in the stub UI (and in your Cloud Editor export) */
extern lv_obj_t *ui_LabelTemp;
extern lv_obj_t *ui_LabelFan;

static void tick_cb(void *arg){ (void)arg; lv_tick_inc(1); hal_tick_1ms(); }

void app_init(void){
    lv_timer_create(tick_cb, 1, NULL);
}

void app_update_ui(void){
    hal_telemetry_t t; hal_read(&t);
    char b[32];
    lv_snprintf(b, sizeof b, "%2.0f°", t.temp_c);
    if (ui_LabelTemp) lv_label_set_text(ui_LabelTemp, b);
    lv_snprintf(b, sizeof b, "Fan %u%%", t.duty);
    if (ui_LabelFan) lv_label_set_text(ui_LabelFan, b);
}
