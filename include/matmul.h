#pragma once
#include "../include/dataset.h"

/* Begin typedef declarations */

/* Begin function prototype declarations */
void matmul(int N, const data_t A[], const data_t B[], data_t C[]);
void matsum(int N, int M, const data_t A[], const data_t B[], data_t C[]);
void compare_matrices(int N, const data_t A[], const data_t B[]);
void print_matrix(int N, const data_t A[]);
