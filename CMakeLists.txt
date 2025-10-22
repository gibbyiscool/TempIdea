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
