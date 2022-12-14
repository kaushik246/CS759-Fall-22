#include "nlm.cuh"
#include <stdio.h>
#include "utils.h"
#include <math.h>
#include <cuda.h>
#include <iostream>

#define FILTER_SIGMA 0.0185
__device__ const float DEV_FILTER_SIGMA = (float)FILTER_SIGMA;

__device__ void compare_patches(float *comp_value, float *patch_i, int j, float *G, float *shared_memory, int pixels, int padding, int patch)
{
    int offset = padding * (pixels + 2 * padding);
    j += offset;
    for (int it1 = 0; it1 < patch; it1++)
    {
        for (int it2 = 0; it2 < patch; it2++)
        {
            int first_index = it1 * patch + it2;
            int second_index = j + (it1 - padding) * (pixels + 2 * padding) + it2 - padding;
            if (patch_i[first_index] != (float)-1 && shared_memory[second_index] != (float)-1)
            {
                float diff = patch_i[first_index] - shared_memory[second_index];
                *comp_value += G[first_index] * (diff * diff);
            }
        }
    }
}

__global__ void nlm_sm(float *nlm_image, float *image, int size_with_padding, float *gaussian_arr, int pixels, int padding, int patch)
{
    int index = blockIdx.x * (blockDim.x + 2 * padding) + (threadIdx.x + padding) + padding * pixels + 2 * padding * padding;
    int row_size = pixels + 2 * padding;
    if (index < size_with_padding)
    {
        extern __shared__ float shared_memory[];
        for (int i = 0; i < patch; i++)
        {
            shared_memory[(threadIdx.x + padding) + i * row_size] = image[(threadIdx.x + padding) + i * row_size];
        }
        if (threadIdx.x == 0)
        {
            for (int row = 0; row < padding; row++)
            {
                for (int col = 0; col < patch; col++)
                {
                    shared_memory[row + col * row_size] = -1;
                }
            }
            for (int row = (padding + pixels); row < row_size; row++)
            {
                for (int col = 0; col < patch; col++)
                {
                    shared_memory[row + col * row_size] = -1;
                }
            }
        }
        __syncthreads();
        float patch_i[9];

        for (int it1 = 0; it1 < patch; it1++)
        {
            for (int it2 = 0; it2 < patch; it2++)
            {
                patch_i[it1 * patch + it2] = image[index + (it1 - padding) * row_size + it2 - padding];
            }
        }

        nlm_image[index] = 0;
        float weight;
        float Z = 0;
        for (int it1 = padding; it1 < pixels + padding; it1++)
        {
            for (int it2 = padding; it2 < (pixels + padding); it2++)
            {
                float comp_value = 0;
                compare_patches(&comp_value, patch_i, it2, gaussian_arr, shared_memory, pixels, padding, patch);
                weight = (float)(exp(-comp_value / (DEV_FILTER_SIGMA * DEV_FILTER_SIGMA)));
                nlm_image[index] += weight * shared_memory[padding * row_size + it2];
                Z += weight;
            }

            __syncthreads();

            for (int i = 0; i < patch - 1; i++)
            {
                shared_memory[(threadIdx.x + padding) + i * row_size] = shared_memory[(threadIdx.x + padding) + (i + 1) * row_size];
            }
            int row_offset = (it1 + 1 - padding) * row_size;

            shared_memory[(threadIdx.x + padding) + (patch - 1) * row_size] = image[row_offset + (threadIdx.x + padding) + (patch - 1) * row_size];
            __syncthreads();
        }

        nlm_image[index] = nlm_image[index] / Z;
    }
}
