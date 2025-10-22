/**
 * @file main.c
 * @brief TempIdea main entry point
 */

#include "pico/stdlib.h"
#include "hardware/i2c.h"
#include "lvgl/lvgl.h"
#include "ui/ui_init.h"
#include "drivers/st7701.h"
#include "drivers/gt911.h"
#include "drivers/emc2101.h"
#include "control/temp_controller.h"

#define I2C_PORT i2c0
#define I2C_SDA_PIN 4
#define I2C_SCL_PIN 5
#define I2C_FREQ 400000

int main() {
    // Initialize stdio
    stdio_init_all();
    
    // Initialize I2C
    i2c_init(I2C_PORT, I2C_FREQ);
    gpio_set_function(I2C_SDA_PIN, GPIO_FUNC_I2C);
    gpio_set_function(I2C_SCL_PIN, GPIO_FUNC_I2C);
    gpio_pull_up(I2C_SDA_PIN);
    gpio_pull_up(I2C_SCL_PIN);
    
    // Initialize LVGL
    lv_init();
    
    // Initialize display driver
    st7701_init();
    
    // Initialize touch controller
    gt911_init(I2C_PORT);
    
    // Initialize fan controller
    emc2101_init(I2C_PORT);
    
    // Initialize UI
    ui_init();
    
    // Initialize temperature controller
    temp_controller_init();
    
    // Main loop
    while (1) {
        lv_timer_handler();
        temp_controller_update();
        sleep_ms(5);
    }
    
    return 0;
}
