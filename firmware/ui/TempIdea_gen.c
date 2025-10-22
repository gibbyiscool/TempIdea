#include "TempIdea_gen.h"

lv_obj_t *ui_MainScreen;
lv_obj_t *ui_LabelTemp;
lv_obj_t *ui_LabelFan;

void TempIdea_init_gen(const char *asset_path){
    (void)asset_path;
    ui_MainScreen = lv_obj_create(NULL);
    lv_obj_set_style_bg_color(ui_MainScreen, lv_color_hex(0x111111), 0);

    ui_LabelTemp = lv_label_create(ui_MainScreen);
    lv_obj_set_style_text_color(ui_LabelTemp, lv_color_white(), 0);
    lv_obj_set_style_text_font(ui_LabelTemp, &lv_font_montserrat_48, 0);
    lv_label_set_text(ui_LabelTemp, "--°");
    lv_obj_align(ui_LabelTemp, LV_ALIGN_CENTER, 0, -20);

    ui_LabelFan = lv_label_create(ui_MainScreen);
    lv_obj_set_style_text_color(ui_LabelFan, lv_color_hex(0xE0E0E0), 0);
    lv_obj_set_style_text_font(ui_LabelFan, &lv_font_montserrat_20, 0);
    lv_label_set_text(ui_LabelFan, "Fan --%");
    lv_obj_align(ui_LabelFan, LV_ALIGN_CENTER, 0, 30);

    lv_scr_load(ui_MainScreen);
}
