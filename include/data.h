#ifndef __DATASET_H
#define __DATASET_H
#define ARRAY_SIZE 100

#define DIM_SIZE 10

typedef int data_t;
static data_t input1_data[ARRAY_SIZE] = {0, 3, 2, 0, 3, 1, 0, 3, 2, 3, 2, 0, 3, 3, 1, 2, 3, 0, 0, 1, 1, 1, 2, 3, 1,
                                         2, 3, 1, 1, 3, 2, 2, 0, 1, 3, 2, 2, 2, 0, 0, 1, 0, 1, 3, 3, 0, 3, 3, 3, 3,
                                         0, 3, 2, 1, 2, 2, 0, 0, 3, 0, 1, 1, 0, 3, 3, 1, 2, 3, 3, 0, 1, 2, 1, 0, 1,
                                         2, 2, 1, 0, 3, 1, 0, 2, 2, 1, 1, 1, 1, 1, 1, 2, 0, 3, 1, 1, 2, 2, 3, 3, 1};

static data_t input2_data[ARRAY_SIZE] = {1, 1, 0, 3, 1, 2, 0, 0, 0, 0, 0, 2, 1, 2, 3, 0, 0, 3, 3, 2, 2, 1, 2, 3, 3,
                                         0, 2, 2, 1, 1, 2, 2, 0, 2, 2, 1, 2, 3, 2, 2, 3, 3, 2, 2, 1, 1, 1, 1, 2, 1,
                                         2, 2, 3, 3, 3, 0, 0, 3, 2, 3, 2, 3, 1, 2, 1, 1, 2, 2, 0, 1, 0, 3, 2, 1, 1,
                                         1, 2, 0, 1, 2, 2, 0, 2, 1, 3, 3, 2, 3, 2, 0, 3, 1, 3, 3, 2, 0, 1, 0, 1, 1};

static data_t verify_data[ARRAY_SIZE] = {
    28, 31, 35, 35, 36, 12, 20, 25, 29, 23, 30, 28, 20, 38, 29, 11, 20, 28, 16, 20, 35, 33, 29, 42, 36,
    13, 24, 32, 23, 25, 21, 33, 20, 30, 23, 12, 13, 22, 20, 21, 39, 38, 32, 39, 34, 23, 32, 29, 25, 22,
    22, 20, 23, 27, 34, 12, 14, 33, 27, 18, 28, 35, 24, 30, 30, 22, 25, 31, 26, 22, 23, 25, 25, 32, 26,
    6,  12, 19, 17, 19, 21, 19, 17, 25, 22, 10, 16, 19, 14, 14, 30, 30, 31, 38, 36, 20, 26, 29, 21, 21};

#endif //__DATASET_H