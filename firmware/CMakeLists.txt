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
