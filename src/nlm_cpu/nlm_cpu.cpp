#include <stdio.h>
#include <iostream>
#include "utils.h"
#include <math.h>
#include <chrono>

using namespace std;
using namespace chrono;

float *nlm_cpu(float *image, int pixels, int padding, int patch)
{
    int size_with_padding = pixels * pixels + 4 * padding * pixels + 4 * padding * padding;
    float *nlm_image = allocate_mem(size_with_padding);

    float *gaussian_arr;

    gaussian_arr = gaussian_filter(patch);

    int new_row_size = pixels + 2 * padding;
    for (int i = padding; i < (pixels + padding); i++)
    {
        for (int j = padding; j < (pixels + padding); j++)
        {
            nlm_image[i * new_row_size + j] = 0;
            float weight;
            float Z = 0;
            for (int k = padding; k < (pixels + padding); k++)
            {
                for (int l = padding; l < (pixels + padding); l++)
                {
                    weight = (float)(exp(-compare_patches(i * new_row_size + j, k * new_row_size + l, image, gaussian_arr, pixels, padding, patch) / (float)(FILTER_SIGMA * FILTER_SIGMA)));
                    nlm_image[i * new_row_size + j] += weight * image[k * new_row_size + l];
                    Z += weight;
                }
            }
            nlm_image[i * new_row_size + j] = nlm_image[i * new_row_size + j] / Z;
        }
    }
    return nlm_image;
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
    auto start = high_resolution_clock::now();
    nlm_image = nlm_cpu(image, pixels, padding, patch);
    auto stop = high_resolution_clock::now();

    auto time = duration_cast<std::chrono::duration<double, std::milli>>(stop - start);
    cout << time.count() << endl;

    write_vals_to_txt(nlm_image, pixels, padding, patch);
    return 0;
}
