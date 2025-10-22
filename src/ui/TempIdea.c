#include "TempIdea.h"
#include "TempIdea_gen.h"
#include "lvgl.h"

static void fmt_temp(char* b, size_t n, float c){
    lv_snprintf(b, n, "%2.0f°", c);
}

void ui_update_values(float temp_c, uint8_t duty){
    char b[32];
    fmt_temp(b, sizeof b, temp_c);
    lv_label_set_text(ui_LabelTemp, b);
    lv_snprintf(b, sizeof b, "Fan %u%%", duty);
    lv_label_set_text(ui_LabelFan, b);
}
