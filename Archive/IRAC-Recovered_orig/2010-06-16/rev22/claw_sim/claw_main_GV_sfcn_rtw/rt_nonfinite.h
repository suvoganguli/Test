/*
 * rt_nonfinite.h
 *
 * Real-Time Workshop code generation for Simulink model "claw_main_GV_sf.mdl".
 *
 * Model Version              : 1.5137
 * Real-Time Workshop version : 6.3  (R14SP3)  26-Jul-2005
 * C source code generated on : Fri May 29 11:09:50 2009
 */
#ifndef _RTW_HEADER_rt_nonfinite_h_
#define _RTW_HEADER_rt_nonfinite_h_

#include <stddef.h>
#include "rtwtypes.h"

extern real_T rtInf;
extern real_T rtMinusInf;
extern real_T rtNaN;
extern real32_T rtInfF;
extern real32_T rtMinusInfF;
extern real32_T rtNaNF;

extern void rt_InitInfAndNaN(size_t realSize);
extern boolean_T rtIsInf(real_T value);
extern boolean_T rtIsInfF(real32_T value);
extern boolean_T rtIsNaN(real_T value);
extern boolean_T rtIsNaNF(real32_T value);

#endif                                  /* _RTW_HEADER_rt_nonfinite_h_ */
