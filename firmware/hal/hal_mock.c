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
