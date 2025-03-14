#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "../include/matmul.h"
#include "../include/utils.h"
#include "../include/dataset.h"

/**
 * @brief Program entry point
 *
 * @param argc - the number of command line arguments
 * @param argv - an array of command line arguments
 * @return int - the exit status
 */
int main(int argc, char* argv[]) {
  if (argc == MIN_ARGS) {
    static data_t results_data[ARRAY_SIZE];
    matsum(DIM_SIZE, DIM_SIZE, input1_data, input2_data, results_data);
    compare_matrices(DIM_SIZE, results_data, verify_data);
  } else {
    usage(*argv);
  }
  return EXIT_SUCCESS;
}