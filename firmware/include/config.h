/**
 * @file config.h
 * @brief TempIdea configuration parameters
 */

#ifndef CONFIG_H
#define CONFIG_H

// I2C Configuration
#define I2C_PORT i2c0
#define I2C_SDA_PIN 4
#define I2C_SCL_PIN 5
#define I2C_FREQ 400000

// EMC2101 Configuration
#define EMC2101_I2C_ADDR 0x4C

// Display Configuration
#define DISPLAY_WIDTH 480
#define DISPLAY_HEIGHT 480

// Temperature Control
#define DEFAULT_TARGET_TEMP 25.0f
#define TEMP_HYSTERESIS 0.5f

#endif // CONFIG_H
