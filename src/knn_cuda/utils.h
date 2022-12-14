#ifndef UTILS_H
#define UTILS_H

#include <cstddef>

#define FILTER_SIGMA 0.0185
#define PATCH_SIGMA 3.1550

float *parse_vals_from_txt(int pixels, int padding);
void write_vals_to_txt(float *image, int pixels, int padding, int patch);
float *allocate_mem(int size);
float *gaussian_filter(int patch);

#endif
