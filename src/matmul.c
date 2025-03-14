#include "../include/matmul.h"
#include "../include/utils.h"
#include <stddef.h>
#include <stdio.h>

/**
 * @brief matmul - A function that multiplies two matrices
 * @param N - The size of the matrices
 * @param A - The first matrix
 * @param B - The second matrix
 * @param C - The result of the multiplication
 */
void matmul(int N, const data_t A[], const data_t B[], data_t C[]) {
  int i, j, k;

  for (i = 0; i < N; i++) {
    for (j = 0; j < N; j++) {
      data_t sum = 0;
      for (k = 0; k < N; k++) sum += A[j * N + k] * B[k * N + i];
      C[i + j * N] = sum;
    }
  }
}

/**
 * @brief matsum - A function that sums two matrices
 * @param N - The size of the matrices
 * @param M - The size of the matrices
 * @param A - The first matrix
 * @param B - The second matrix
 * @param C - The result of the sum
 */
void matsum(int N, int M, const data_t A[], const data_t B[], data_t C[]) {
  int i, j;

  for (i = 0; i < N; i++) {
    for (j = 0; j < M; j++) { C[i * N + j] = A[i * N + j] + B[i * N + j]; }
  }
}

/**
 * @brief compare_matrices - A function that compares two matrices
 * @param N - The size of the matrices
 * @param A - The first matrix
 * @param B - The second matrix
 */
void compare_matrices(int N, const data_t A[], const data_t B[]) {
  int i, j;

  for (i = 0; i < N; i++) {
    for (j = 0; j < N; j++) {
      if (A[i * N + j] != B[i * N + j]) {
        printf("Verification failed at position (%d, %d)\n", i, j);
        return;
      }
    }
  }
  printf("Verification successful\n");
}

/**
 * @brief print_matrix - A function that prints an NxN matrix
 * @param N - The size of the matrix
 * @param A - The matrix to print
 */
void print_matrix(int N, const data_t A[]) {
  int i, j;

  for (i = 0; i < N; i++) {
    for (j = 0; j < N; j++) { printf("%d ", A[i * N + j]); }
    printf("\n");
  }
}
