#ifndef UTILS_H
#define UTILS_H

#include <cstddef>

float *parse_vals_from_txt(int pixels, int padding);
void write_vals_to_txt(float *image, int pixels, int padding, int patch);
float *allocate_mem(int size);

#endif
