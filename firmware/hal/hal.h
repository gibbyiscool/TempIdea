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
