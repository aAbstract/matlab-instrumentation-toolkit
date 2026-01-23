#ifndef HAL_H
#define HAL_H

#include <stdint.h>

#define RC_HAL_OK 0
#define RC_HAL_ERR_TIMEOUT 1

int16_t HAL_Read_Level(float* out_level);
uint32_t HAL_Read_Clock();
float HAL_Read_Pump();
void HAL_Write_Pump(float pump);

#endif
