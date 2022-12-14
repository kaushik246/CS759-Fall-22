#include "knn.cuh"
#include <stdio.h>
#include <math.h>

#define FILTER_SIGMA 0.0185
#define PATCH_SIGMA 3.1550

__device__ const float DEV_FILTER_SIGMA = (float)FILTER_SIGMA;

__device__ void compare_patches(float *comp, float *image, float *gaussian_arr, int i, int j, int pixels, int padding, int patch)
{
    for (int m = 0; m < patch; m++)
    {
        for (int n = 0; n < patch; n++)
        {
            int idx_1 = i + (m - padding) * (pixels + 2 * padding) + n - padding;
            int idx_2 = j + (m - padding) * (pixels + 2 * padding) + n - padding;
            if (image[idx_1] != (float)-1 && image[idx_2] != (float)-1)
            {
                float diff = image[idx_1] - image[idx_2];
                *comp += gaussian_arr[m * patch + n] * (diff * diff);
            }
        }
    }
}
__global__ void knn(float *knn_image, float *image, int size_with_padding, float *gaussian_arr, int pixels, int padding, int patch)
{
    int index = blockIdx.x * (blockDim.x + 2 * padding) + (threadIdx.x + padding) + padding * pixels + 2 * padding * padding;
    int row_size = pixels + 2 * padding;
    if (index < size_with_padding)
    {
        knn_image[index] = 0;
        float weight;
        float Z = 0;
        for (int i = padding; i < (pixels + padding); i++)
        {
            for (int j = padding; j < (pixels + padding); j++)
            {
                float comp = 0;
                compare_patches(&comp, image, gaussian_arr, index, i * (pixels + 2 * padding) + j, pixels, padding, patch);
                weight = (float)(exp(-comp / (DEV_FILTER_SIGMA * DEV_FILTER_SIGMA)));
                knn_image[index] += weight * image[i * row_size + j];
                Z += weight;
            }
        }
        knn_image[index] = knn_image[index] / Z;
    }
}
