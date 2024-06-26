/*
 * File: quaternion.c
 *
 * MATLAB Coder version            : 5.2
 * C/C++ source code generated on  : 27-Jan-2023 16:28:27
 */

/* Include Files */
#include "quaternion.h"
#include "rt_nonfinite.h"
#include "rt_nonfinite.h"
#include <math.h>

/* Function Definitions */
/*
 * Arguments    : const double varargin_1[3]
 *                double *obj_a
 *                double *obj_b
 *                double *obj_c
 *                double *obj_d
 * Return Type  : void
 */
void b_quaternion_quaternion(const double varargin_1[3], double *obj_a,
                             double *obj_b, double *obj_c, double *obj_d)
{
  double st;
  double theta;
  *obj_a = 1.0;
  *obj_b = 0.0;
  *obj_c = 0.0;
  *obj_d = 0.0;
  theta = sqrt((varargin_1[0] * varargin_1[0] + varargin_1[1] * varargin_1[1]) +
               varargin_1[2] * varargin_1[2]);
  st = sin(theta / 2.0);
  if (theta != 0.0) {
    *obj_a = cos(theta / 2.0);
    *obj_b = varargin_1[0] / theta * st;
    *obj_c = varargin_1[1] / theta * st;
    *obj_d = varargin_1[2] / theta * st;
  }
}

/*
 * Arguments    : const double varargin_1[9]
 *                double *obj_a
 *                double *obj_b
 *                double *obj_c
 *                double *obj_d
 * Return Type  : void
 */
void quaternion_quaternion(const double varargin_1[9], double *obj_a,
                           double *obj_b, double *obj_c, double *obj_d)
{
  double psquared[4];
  double pa;
  double pd;
  int i;
  int idx;
  int k;
  boolean_T exitg1;
  pd = (varargin_1[0] + varargin_1[4]) + varargin_1[8];
  psquared[0] = (2.0 * pd + 1.0) - pd;
  psquared[1] = (2.0 * varargin_1[0] + 1.0) - pd;
  psquared[2] = (2.0 * varargin_1[4] + 1.0) - pd;
  psquared[3] = (2.0 * varargin_1[8] + 1.0) - pd;
  if (!rtIsNaN(psquared[0])) {
    idx = 1;
  } else {
    idx = 0;
    k = 2;
    exitg1 = false;
    while ((!exitg1) && (k < 5)) {
      if (!rtIsNaN(psquared[k - 1])) {
        idx = k;
        exitg1 = true;
      } else {
        k++;
      }
    }
  }
  if (idx == 0) {
    pd = psquared[0];
    idx = 1;
  } else {
    pd = psquared[idx - 1];
    i = idx + 1;
    for (k = i; k < 5; k++) {
      pa = psquared[k - 1];
      if (pd < pa) {
        pd = pa;
        idx = k;
      }
    }
  }
  switch (idx) {
  case 1:
    pa = sqrt(pd);
    *obj_a = 0.5 * pa;
    pd = 0.5 / pa;
    *obj_b = pd * (varargin_1[7] - varargin_1[5]);
    *obj_c = pd * (varargin_1[2] - varargin_1[6]);
    *obj_d = pd * (varargin_1[3] - varargin_1[1]);
    break;
  case 2:
    pd = sqrt(pd);
    *obj_b = 0.5 * pd;
    pd = 0.5 / pd;
    *obj_a = pd * (varargin_1[7] - varargin_1[5]);
    *obj_c = pd * (varargin_1[1] + varargin_1[3]);
    *obj_d = pd * (varargin_1[2] + varargin_1[6]);
    break;
  case 3:
    pd = sqrt(pd);
    *obj_c = 0.5 * pd;
    pd = 0.5 / pd;
    *obj_a = pd * (varargin_1[2] - varargin_1[6]);
    *obj_b = pd * (varargin_1[1] + varargin_1[3]);
    *obj_d = pd * (varargin_1[5] + varargin_1[7]);
    break;
  default:
    pd = sqrt(pd);
    *obj_d = 0.5 * pd;
    pd = 0.5 / pd;
    *obj_a = pd * (varargin_1[3] - varargin_1[1]);
    *obj_b = pd * (varargin_1[2] + varargin_1[6]);
    *obj_c = pd * (varargin_1[5] + varargin_1[7]);
    break;
  }
  if (*obj_a < 0.0) {
    *obj_a = -*obj_a;
    *obj_b = -*obj_b;
    *obj_c = -*obj_c;
    *obj_d = -*obj_d;
  }
}

/*
 * File trailer for quaternion.c
 *
 * [EOF]
 */
