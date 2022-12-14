#include <stdio.h>
#include <iostream>
#include "utils.h"
#include <math.h>
#include <chrono>

using namespace std;
using namespace chrono;

float *knn_cpu(float *image, int pixels, int padding, int patch)
{
    int size_with_padding = pixels * pixels + 4 * padding * pixels + 4 * padding * padding;
    float *knn_image = allocate_mem(size_with_padding);

    int new_row_size = pixels + 2 * padding;
    int count = 0;
    for (int i = padding; i < (pixels + padding); i++)
    {
        for (int j = padding; j < (pixels + padding); j++)
        {
            knn_image[i * new_row_size + j] = 0;
            float weight;
            float Z = 0;
            for (int k = padding; k < (pixels + padding); k++)
            {
                for (int l = padding; l < (pixels + padding); l++)
                {
                    float diff = image[i * new_row_size + j] - image[k * new_row_size + l];
                    weight = (float)exp((diff * diff * -1) / (float)(FILTER_SIGMA * FILTER_SIGMA));
                    knn_image[i * new_row_size + j] += weight * image[k * new_row_size + l];
                    Z += weight;
                }
            }
            knn_image[i * new_row_size + j] = knn_image[i * new_row_size + j] / Z;
        }
    }
    return knn_image;
}

int main(int argc, char *argv[])
{
    int pixels = atoi(argv[1]);
    int patch = atoi(argv[2]);
    string file_name = argv[3];

    int padding = patch / 2;

    float *image;
    image = parse_vals_from_txt(pixels, padding);

    float *knn_image;
    auto start = high_resolution_clock::now();
    knn_image = knn_cpu(image, pixels, padding, patch);
    auto stop = high_resolution_clock::now();

    auto time = duration_cast<std::chrono::duration<double, std::milli>>(stop - start);
    cout << time.count() << endl;

    write_vals_to_txt(knn_image, pixels, padding, patch);

    free(image);
    free(knn_image);

    return 0;
}
