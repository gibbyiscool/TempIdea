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
