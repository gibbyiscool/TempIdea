#pragma once
#include "lvgl.h"
#ifdef __cplusplus
extern "C" {
#endif
extern lv_obj_t *ui_MainScreen;
extern lv_obj_t *ui_LabelTemp;
extern lv_obj_t *ui_LabelFan;
void TempIdea_init_gen(const char *asset_path);
#ifdef __cplusplus
}
#endif
