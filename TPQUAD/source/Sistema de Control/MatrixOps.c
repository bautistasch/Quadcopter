/*
 * MatrixOps.c
 *
 *  Created on: Feb 14, 2023
 *      Author: sch_b
 */

#include "MatrixOps.h"


void matrix_mult(uint8_t m, uint8_t n, uint8_t p, const float A[m][n], const float B[n][p], float C[m][p])
{
	for (uint8_t i = 0; i < m; i++) {
		for (uint8_t j = 0; j < p; j++) {
			float sum = 0.0;
			for (uint8_t k = 0; k < n; k++) {
				sum += A[i][k] * B[k][j];
			}
			C[i][j] = sum;
		}
	}
}

void scalar_mult(uint8_t m, uint8_t n, float scalar, float InOut[m][n]){
	for(uint8_t i = 0; i < m; i++){
		for(uint8_t j = 0; j < n; j++){
			InOut[i][j] = scalar*InOut[i][j];
		}
	}
}

void matrix_add_sub(uint8_t m, uint8_t n, const float A[m][n], char sign, const float B[m][n], float C[m][n]) {
	int8_t signtmp = sign == '-'? -1 : 1;
    for (uint8_t i = 0; i < m; i++) {
        for (uint8_t j = 0; j < n; j++) {
            C[i][j] = A[i][j] + signtmp*B[i][j];
        }
    }
}
