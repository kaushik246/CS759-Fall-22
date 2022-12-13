#include "nlm.cuh"
#include <stdio.h>
#include <iostream>
#include "utils.h"
#include <math.h>
#include <cuda.h>

using namespace std;

void nlm_cuda(float *image, float *nlm_image, int pixels, int padding, int patch)
{
    int size_with_padding = pixels * pixels + 4 * padding * pixels + 4 * padding * padding;

    float *gaussian_arr;
    gaussian_arr = gaussian_filter(patch);

    float *dev_gaussian_arr;
    cudaMallocManaged(&dev_gaussian_arr, patch * patch * sizeof(float));

    cudaMemcpy(&dev_gaussian_arr, gaussian_arr, sizeof(float) * pixels * pixels, cudaMemcpyHostToDevice);

    nlm_sm<<<pixels, pixels>>>(nlm_image, image, size_with_padding, dev_gaussian_arr);
    cudaDeviceSynchronize();

    free(gaussian_arr);
    cudaFree(dev_gaussian_arr);
}

int main(int argc, char *argv[])
{
    int pixels = atoi(argv[1]);
    int patch = atoi(argv[2]);
    string file_name = argv[3];

    int padding = patch / 2;

    int size_with_padding = pixels * pixels + 4 * padding * pixels + 4 * padding * padding;

    float *image;
    image = parse_vals_from_txt(pixels, padding);

    float *dev_image;
    cudaMallocManaged((void **)&dev_image, size_with_padding * sizeof(float));
    cudaMemcpy(&dev_image, image, sizeof(float) * size_with_padding, cudaMemcpyHostToDevice);

    float *nlm_image;
    cudaMallocManaged((void **)&nlm_image, size_with_padding * sizeof(float));
    for (int i = 0; i < size_with_padding; i++)
    {
        filtered_image[i] = (float)-1;
    }

    nlm_cuda(dev_image, nlm_image, pixels, padding, patch);

    write_vals_to_txt(nlm_image, pixels, padding, patch);

    cudaFree(nlm_image);
    cudaFree(dev_image);
    free(image);

    return 0;
}