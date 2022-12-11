#include <stdio.h>
#include <iostream>
#include "utils.h"
#include <math.h>

#define FILTER_SIGMA 0.0185
#define PATCH_SIGMA 3.1550

using namespace std;

float *gaussian_filter(int patch)
{
    float *gaussian_arr = allocate_mem(patch * patch);

    int bound = patch / 2;
    for (int x = -bound; x <= bound; x++)
    {
        for (int y = -bound; y <= bound; y++)
        {
            int index = (x + bound) * patch + (y + bound);
            gaussian_arr[index] = exp(-(float)(x * x + y * y) / (float)(2 * PATCH_SIGMA * PATCH_SIGMA)) / (float)(2 * M_PI * PATCH_SIGMA * PATCH_SIGMA);
        }
    }
    return gaussian_arr;
}

float compare_patches(int i, int j, float *image, float *G, int pixels, int padding, int patch)
{
    float patch_comp = 0;
    for (int m = 0; m < patch; m++)
    {
        for (int n = 0; n < patch; n++)
        {
            int first_index = i + (m - padding) * (pixels + 2 * padding) + n - padding;
            int second_index = j + (m - padding) * (pixels + 2 * padding) + n - padding;

            if ((image[first_index] != (float)-1) && (image[second_index] != (float)-1))
            {
                float diff = image[first_index] - image[second_index];
                patch_comp += G[m * pixels + n] * (diff * diff);
            }
        }
    }
    return patch_comp;
}

float *nlm_cpu(float *image, int pixels, int padding, int patch)
{
    int padded_size = pixels * pixels + 4 * (padding * pixels + padding * padding);
    float *filtered_image = allocate_mem(padded_size);

    float *gaussian_arr;

    gaussian_arr = gaussian_filter(patch);

    int row_size = pixels + 2 * padding;
    for (int it1 = padding; it1 < (pixels + padding); it1++)
    {
        for (int it2 = padding; it2 < (pixels + padding); it2++)
        {
            filtered_image[it1 * row_size + it2] = 0;
            float weight;
            float Z = 0;
            for (int it3 = padding; it3 < (pixels + padding); it3++)
            {
                for (int it4 = padding; it4 < (pixels + padding); it4++)
                {
                    weight = (float)(exp(-compare_patches(it1 * row_size + it2, it3 * row_size + it4, image, gaussian_arr, pixels, padding, patch) / (float)(FILTER_SIGMA * FILTER_SIGMA)));
                    filtered_image[it1 * row_size + it2] += weight * image[it3 * row_size + it4];
                    Z += weight;
                }
            }
            filtered_image[it1 * row_size + it2] = filtered_image[it1 * row_size + it2] / Z;
        }
    }
    return filtered_image;
}

int main(int argc, char *argv[])
{
    int pixels = atoi(argv[1]);
    int patch = atoi(argv[2]);
    string file_name = argv[3];

    int padding = patch / 2;

    float *image;
    image = parse_vals_from_txt(pixels, padding);

    float *nlm_image;
    nlm_image = nlm_cpu(image, pixels, padding, patch);

    write_vals_to_txt(nlm_image, pixels, padding, patch);
    return 0;
}
