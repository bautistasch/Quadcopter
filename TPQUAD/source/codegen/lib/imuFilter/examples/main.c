/*
 * File: main.c
 *
 * MATLAB Coder version            : 5.2
 * C/C++ source code generated on  : 27-Jan-2023 16:28:27
 */

/*************************************************************************/
/* This automatically generated example C main file shows how to call    */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/

/* Include Files */
#include "main.h"
#include "imuFilter.h"
#include "imuFilter_terminate.h"
#include "rt_nonfinite.h"

/* Function Declarations */
static void argInit_1x3_real_T(double result[3]);

static double argInit_real_T(void);

static void main_imuFilter(void);

/* Function Definitions */
/*
 * Arguments    : double result[3]
 * Return Type  : void
 */
static void argInit_1x3_real_T(double result[3])
{
  int idx1;
  /* Loop over the array to initialize each element. */
  for (idx1 = 0; idx1 < 3; idx1++) {
    /* Set the value of the array element.
Change this value to the value that the application requires. */
    result[idx1] = argInit_real_T();
  }
}

/*
 * Arguments    : void
 * Return Type  : double
 */
static double argInit_real_T(void)
{
  return 0.0;
}

/*
 * Arguments    : void
 * Return Type  : void
 */
static void main_imuFilter(void)
{
  double AccMatrix_tmp[3];
  double angles[3];
  /* Initialize function 'imuFilter' input arguments. */
  /* Initialize function input argument 'AccMatrix'. */
  argInit_1x3_real_T(AccMatrix_tmp);
  /* Initialize function input argument 'GyroMatrix'. */
  /* Call the entry-point 'imuFilter'. */
  imuFilter(argInit_real_T(), AccMatrix_tmp, AccMatrix_tmp, angles);
}

/*
 * Arguments    : int argc
 *                char **argv
 * Return Type  : int
 */
int main(int argc, char **argv)
{
  (void)argc;
  (void)argv;
  /* The initialize function is being called automatically from your entry-point
   * function. So, a call to initialize is not included here. */
  /* Invoke the entry-point functions.
You can call entry-point functions multiple times. */
  main_imuFilter();
  /* Terminate the application.
You do not need to do this more than one time. */
  imuFilter_terminate();
  return 0;
}

/*
 * File trailer for main.c
 *
 * [EOF]
 */
