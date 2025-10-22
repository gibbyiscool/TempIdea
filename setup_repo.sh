#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${1:-tempidea}"

echo "🔧 Setting up repo: ${APP_NAME}"

# --- directories
mkdir -p .devcontainer
mkdir -p src/port
mkdir -p src/hal
mkdir -p src/ui
touch .gitignore

# --- .gitignore
cat > .gitignore << 'EOF'
build/
.vscode/
*.o
*.a
*.out
*.log
.DS_Store
EOF

# --- devcontainer
cat > .devcontainer/devcontainer.json << 'EOF'
{
  "name": "TempIdea (LVGL PC sim)",
  "image": "mcr.microsoft.com/devcontainers/cpp:ubuntu",
  "postCreateCommand": "sudo apt-get update && sudo apt-get install -y cmake libsdl2-dev && mkdir -p build && cd build && cmake .. && make -j",
  "customizations": {
    "vscode": {
      "extensions": ["ms-vscode.cmake-tools", "twxs.cmake", "ms-vscode.cpptools"]
    }
  }
}
EOF

# --- CMakeLists.txt (FetchContent LVGL)
cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.16)
project(tempidea_sim C)

set(CMAKE_C_STANDARD 11)
add_definitions(-DLV_CONF_INCLUDE_SIMPLE)

include(FetchContent)

# Pull LVGL at configure time (no code committed)
FetchContent_Declare(
  lvgl
  GIT_REPOSITORY https://github.com/lvgl/lvgl.git
  GIT_TAG release/v9.1
)
FetchContent_MakeAvailable(lvgl)

# SDL2 for PC sim
find_package(PkgConfig REQUIRED)
pkg_check_modules(SDL2 REQUIRED sdl2)

# LVGL's SDL helpers (v9)
file(GLOB LV_SDL_SRCS ${lvgl_SOURCE_DIR}/src/drivers/sdl/*.c)

add_executable(sim
  src/main.c
  src/port/sdl_port.c
  src/hal/hal_sim.c
  src/ui/TempIdea_gen.c
  src/ui/TempIdea.c
  ${LV_SDL_SRCS}
)

target_include_directories(sim PRIVATE
  .
  src
  ${lvgl_SOURCE_DIR}
)

target_link_libraries(sim PRIVATE lvgl ${SDL2_LIBRARIES})
target_include_directories(sim PRIVATE ${SDL2_INCLUDE_DIRS})

add_compile_definitions(LV_USE_PERF_MONITOR=1)
EOF

# --- lv_conf.h (minimal)
cat > lv_conf.h << 'EOF'
#ifndef LV_CONF_H
#define LV_CONF_H

#define LV_USE_LOG 1
#define LV_LOG_LEVEL LV_LOG_LEVEL_WARN

#define LV_USE_DRV_SDL 1
#define LV_USE_DRAW_SDL 1
#define LV_USE_SDL_GPU 0

#define LV_HOR_RES_MAX 480
#define LV_VER_RES_MAX 480

#define LV_FONT_DEFAULT_MONTSERRAT_16 1
#define LV_FONT_MONTSERRAT_20 1
#define LV_FONT_MONTSERRAT_36 1
#define LV_FONT_MONTSERRAT_48 1

#endif
EOF

# --- SDL port
cat > src/port/sdl_port.h << 'EOF'
#pragma once
#include "lvgl.h"
void sdl_port_init(uint16_t hor, uint16_t ver);
EOF

cat > src/port/sdl_port.c << 'EOF'
#include "sdl_port.h"
#include "lvgl/src/drivers/sdl/lv_sdl_window.h"
#include "lvgl/src/drivers/sdl/lv_sdl_mouse.h"

void sdl_port_init(uint16_t hor, uint16_t ver){
    lv_sdl_window_create(hor, ver);  /* creates LVGL display bound to SDL window */
    lv_sdl_mouse_create();           /* mouse acts as touch */
}
EOF

# --- HAL (sim)
cat > src/hal/hal.h << 'EOF'
#pragma once
#include <stdint.h>
#include <stdbool.h>

typedef struct { float temp_c; uint8_t duty; } hal_telemetry_t;

void hal_init(void);
void hal_tick_1ms(void);
void hal_read(hal_telemetry_t* o);
void hal_set_target(float c);
void hal_set_manual(bool en, uint8_t duty);
EOF

cat > src/hal/hal_sim.c << 'EOF'
#include "hal.h"

static float target=30.0f, temp=27.0f;
static uint8_t duty=20;
static bool manual=false;
static uint8_t mduty=60;

void hal_init(void) {}

void hal_tick_1ms(void){
  /* crude thermal sim */
  float load=6.0f, cool=(manual?mduty:duty)*0.03f;
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

# --- Minimal UI (stub; replace with Cloud Editor export later)
cat > src/ui/TempIdea_gen.h << 'EOF'
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

cat > src/ui/TempIdea_gen.c << 'EOF'
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

cat > src/ui/TempIdea.h << 'EOF'
#pragma once
#include <stdint.h>
void ui_update_values(float temp_c, uint8_t duty);
EOF

cat > src/ui/TempIdea.c << 'EOF'
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
EOF

# --- main.c
cat > src/main.c << 'EOF'
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
EOF

# --- Git init (optional if already a repo)
if [ ! -d .git ]; then
  git init
  git add .
  git commit -m "chore: bootstrap ${APP_NAME} (LVGL PC sim via FetchContent)"
fi

echo "✅ Repo files created."
echo "➡️  Next in Codespaces:"
echo "   mkdir -p build && cd build && cmake .. && make -j && ./sim"
echo "💡 Replace src/ui/TempIdea_gen.* later with your LVGL Cloud Editor export."
