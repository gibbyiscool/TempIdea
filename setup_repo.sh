#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${1:-tempidea}"

echo "🔧 Scaffolding repo: ${APP_NAME}"
mkdir -p "$APP_NAME"
cd "$APP_NAME"

# ---------------------------
# Repo layout
# ---------------------------
mkdir -p .devcontainer
mkdir -p tools
mkdir -p editor/{components,fonts,images,preview-bin,screens,widgets}
mkdir -p firmware/{app,ui,hal,ports/{sim,rp2350}}

# ---------------------------
# .gitignore
# ---------------------------
cat > .gitignore << 'EOF'
build/
.vscode/
*.o
*.a
*.out
*.log
.DS_Store
# LVGL Editor preview cache
editor/preview-bin/
EOF

# ---------------------------
# Devcontainer (Codespaces)
# ---------------------------
cat > .devcontainer/devcontainer.json << 'EOF'
{
  "name": "TempIdea (LVGL PC sim)",
  "image": "mcr.microsoft.com/devcontainers/cpp:ubuntu",
  "postCreateCommand": "sudo apt-get update && sudo apt-get install -y cmake libsdl2-dev rsync && mkdir -p build && cd build && cmake .. && make -j && ./sim || true",
  "customizations": {
    "vscode": {
      "extensions": ["ms-vscode.cmake-tools","twxs.cmake","ms-vscode.cpptools"]
    }
  }
}
EOF

# ---------------------------
# Top-level CMake -> firmware
# ---------------------------
cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.16)
project(tempidea_super C)
add_subdirectory(firmware)
EOF

# ---------------------------
# LVGL config (shared)
# ---------------------------
cat > firmware/lv_conf.h << 'EOF'
#ifndef LV_CONF_H
#define LV_CONF_H

#define LV_USE_LOG 1
#define LV_LOG_LEVEL LV_LOG_LEVEL_WARN

/* PC simulator (SDL) */
#define LV_USE_DRV_SDL 1
#define LV_USE_DRAW_SDL 1
#define LV_USE_SDL_GPU 0

/* Match target panel size */
#define LV_HOR_RES_MAX 480
#define LV_VER_RES_MAX 480

/* Fonts used by stubs (Cloud Editor export can add more) */
#define LV_FONT_DEFAULT_MONTSERRAT_16 1
#define LV_FONT_MONTSERRAT_20 1
#define LV_FONT_MONTSERRAT_36 1
#define LV_FONT_MONTSERRAT_48 1

#endif
EOF

# ---------------------------
# Firmware CMake
# ---------------------------
cat > firmware/CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.16)
project(tempidea_fw C)
set(CMAKE_C_STANDARD 11)
add_definitions(-DLV_CONF_INCLUDE_SIMPLE)

include(FetchContent)
# Pull LVGL (no code committed)
FetchContent_Declare(
  lvgl
  GIT_REPOSITORY https://github.com/lvgl/lvgl.git
  GIT_TAG release/v9.1
)
FetchContent_MakeAvailable(lvgl)

# ---------- SIM (SDL2) ----------
find_package(PkgConfig REQUIRED)
pkg_check_modules(SDL2 REQUIRED sdl2)

# LVGL v9 SDL helper sources
file(GLOB LV_SDL_SRCS ${lvgl_SOURCE_DIR}/src/drivers/sdl/*.c)

# Pick up whatever the LVGL editor exported to firmware/ui/
file(GLOB_RECURSE UI_SRCS
  ui/*.c
)

add_executable(sim
  main_sim.c
  ports/sim/sdl_port.c
  hal/hal_mock.c
  app/app.c
  ${UI_SRCS}
  ${LV_SDL_SRCS}
)

target_include_directories(sim PRIVATE
  .
  ${lvgl_SOURCE_DIR}
)

target_link_libraries(sim PRIVATE lvgl ${SDL2_LIBRARIES})
target_include_directories(sim PRIVATE ${SDL2_INCLUDE_DIRS})
add_compile_definitions(LV_USE_PERF_MONITOR=1)

# ---------- (future) RP2350 ----------
add_library(rp2350_port STATIC
  ports/rp2350/rp2350_port.c
)
target_include_directories(rp2350_port PUBLIC . ${lvgl_SOURCE_DIR})

add_executable(rp2350_fw
  main_rp2350.c
  hal/hal_mock.c        # swap to hal_rp2350.c later
  app/app.c
  ${UI_SRCS}
)
target_link_libraries(rp2350_fw PRIVATE rp2350_port lvgl)
target_compile_definitions(rp2350_fw PRIVATE TARGET_RP2350=1)
EOF

# ---------------------------
# Ports: SDL (sim) + RP2350 stubs
# ---------------------------
cat > firmware/ports/sim/sdl_port.h << 'EOF'
#pragma once
#include "lvgl.h"
void sdl_port_init(uint16_t hor, uint16_t ver);
EOF

cat > firmware/ports/sim/sdl_port.c << 'EOF'
#include "sdl_port.h"
#include "lvgl/src/drivers/sdl/lv_sdl_window.h"
#include "lvgl/src/drivers/sdl/lv_sdl_mouse.h"

void sdl_port_init(uint16_t hor, uint16_t ver){
    lv_sdl_window_create(hor, ver);
    lv_sdl_mouse_create();
}
EOF

cat > firmware/ports/rp2350/rp2350_port.h << 'EOF'
#pragma once
#include "lvgl.h"
/* TODO: implement ST7701/GT911 init on hardware */
void rp2350_port_init(void);
EOF

cat > firmware/ports/rp2350/rp2350_port.c << 'EOF'
#include "rp2350_port.h"
void rp2350_port_init(void){ /* TODO: hardware display/touch init */ }
EOF

# ---------------------------
# HAL (mock for sim)
# ---------------------------
cat > firmware/hal/hal.h << 'EOF'
#pragma once
#include <stdint.h>
#include <stdbool.h>

typedef struct {
  float   temp_c;
  uint8_t duty;   // 0..100
} hal_telemetry_t;

void hal_init(void);
void hal_tick_1ms(void);
void hal_read(hal_telemetry_t* o);
void hal_set_target(float c);
void hal_set_manual(bool en, uint8_t d);
EOF

cat > firmware/hal/hal_mock.c << 'EOF'
#include "hal.h"

static float target=30.0f, temp=27.0f;
static uint8_t duty=20;
static bool manual=false;
static uint8_t mduty=60;

void hal_init(void) {}

void hal_tick_1ms(void){
  /* crude thermal model */
  const float load=6.0f;
  const float cool=(manual?mduty:duty)*0.03f;
  temp += (load - cool)*0.002f;

  if(!manual){
    if(temp > target + 3 && duty < 100) duty++;
    else if(temp < target - 3 && duty > 20) duty--;
  }
}

void hal_read(hal_telemetry_t* o){ o->temp_c=temp; o->duty = manual?mduty:duty; }
void hal_set_target(float c){ target=c; }
void hal_set_manual(bool en, uint8_t d){ manual=en; mduty=d; }
EOF

# ---------------------------
# App glue
# ---------------------------
cat > firmware/app/app.h << 'EOF'
#pragma once
void app_init(void);
void app_update_ui(void);   // call ~4x/sec
EOF

cat > firmware/app/app.c << 'EOF'
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
EOF

# ---------------------------
# UI stub (replace with editor export)
# ---------------------------
cat > firmware/ui/TempIdea_gen.h << 'EOF'
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
EOF

cat > firmware/ui/TempIdea_gen.c << 'EOF'
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
EOF

# ---------------------------
# Entrypoints
# ---------------------------
cat > firmware/main_sim.c << 'EOF'
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
EOF

cat > firmware/main_rp2350.c << 'EOF'
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
EOF

# ---------------------------
# LVGL Editor project placeholders
# ---------------------------
cat > editor/project.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<project lvgl_version="9.1" name="TempIdea">
  <includes>
    <file>globals.xml</file>
  </includes>
  <screens/>
</project>
EOF

cat > editor/globals.xml << 'EOF'
<globals>
  <api>
    <enumdefs>
      <enum name="units_mode">
        <member name="Celsius" value="0"/>
        <member name="Fahrenheit" value="1"/>
      </enum>
    </enumdefs>
  </api>
  <consts>
    <color name="col_bg_dark" value="#111111"/>
    <color name="col_text"    value="#FFFFFF"/>
    <color name="col_text_sm" value="#E0E0E0"/>
    <int name="long_press_ms" value="700"/>
  </consts>
  <fonts>
    <tiny_ttf name="font_m20" src="Montserrat-Regular.ttf" size="20"/>
    <tiny_ttf name="font_m48" src="Montserrat-Regular.ttf" size="48"/>
  </fonts>
  <styles>
    <style name="st_bg_dark">
      <prop name="bg_color" value="@col_bg_dark"/>
      <prop name="bg_opa"   value="255"/>
    </style>
    <style name="st_lbl_big">
      <prop name="text_color" value="@col_text"/>
      <prop name="text_font"  value="font_m48"/>
    </style>
    <style name="st_lbl_sm">
      <prop name="text_color" value="@col_text_sm"/>
      <prop name="text_font"  value="font_m20"/>
    </style>
  </styles>
</globals>
EOF

# (Optional) editor-side CMake list placeholder
cat > editor/file_list_gen.cmake << 'EOF'
# Generated by LVGL Cloud Editor (placeholder).
# The editor will overwrite this when exporting C.
EOF

# ---------------------------
# UI sync helper
# ---------------------------
cat > tools/sync_ui.sh << 'EOF'
#!/usr/bin/env bash
set -euo pipefail
SRC_DIR="${1:-editor/export_c}"   # adjust to your editor's export folder
DST_DIR="firmware/ui"
mkdir -p "$DST_DIR"
if command -v rsync >/dev/null 2>&1; then
  rsync -av --include="*/" --include="*.c" --include="*.h" --exclude="*" "$SRC_DIR/" "$DST_DIR/"
else
  find "$SRC_DIR" -type f \( -name "*.c" -o -name "*.h" \) -exec cp {} "$DST_DIR"/ \;
fi
echo "✅ UI synced to $DST_DIR"
EOF
chmod +x tools/sync_ui.sh

# ---------------------------
# Git init & first build hint
# ---------------------------
if [ ! -d .git ]; then git init; fi
git add .
git commit -m "chore: scaffold repo (editor/ + firmware/ with SDL sim; LVGL via FetchContent)"

echo "✅ Done."
echo "➡️  Build locally/Codespaces:"
echo "   mkdir -p build && cd build && cmake .. && make -j && ./sim"
echo "📦 When you export C from LVGL Cloud Editor, run:"
echo "   bash tools/sync_ui.sh path/to/export_c"
