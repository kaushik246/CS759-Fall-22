#include <stdio.h>
#include <iostream>
#include "utils.h"
#include <math.h>

using namespace std;

float *parse_vals_from_txt(int pixels, int padding)
{
    int padded_size = pixels * pixels + 4 * padding * pixels + 4 * padding * padding;
    float *image = (float *)malloc(padded_size * sizeof(float));

    for (int i = 0; i < padded_size; i++)
    {
        image[i] = -1;
    }

    FILE *f = fopen("noisy_image.txt", "r");

    for (int i = padding; i < (pixels + padding); i++)
    {
        for (int j = padding; j < (pixels + padding); j++)
        {
            if (j != (pixels + padding - 1))
            {
                if (fscanf(f, "%f\t", &image[i * (pixels + (2 * padding)) + j]) != 1)
                {
                    printf("Error reading from file.\n");
                }
            }
            else
            {
                if (fscanf(f, "%f\n", &image[i * (pixels + (2 * padding)) + j]) != 1)
                {
                    printf("Error reading from file.\n");
                }
            }
        }
    }

    fclose(f);
    return image;
}

void write_vals_to_txt(float *image, int pixels, int padding, int patch)
{
    FILE *f = fopen("filtered_image.txt", "w");

    int pixels_counter = 0;
    int padded_size = pixels * pixels + 4 * padding * pixels + 4 * padding * padding;
    int start = pixels * padding + 2 * padding * padding + padding;

    for (int i = start; i < (padded_size - start); i++)
    {
        fprintf(f, "%f ", image[i]);
        pixels_counter++;
        if (pixels_counter == pixels)
        {
            pixels_counter = 0;
            i += 2 * padding;
            fprintf(f, "\n");
        }
    }
    fclose(f);
}

float *allocate_mem(int size)
{
    float *arr = (float *)malloc(sizeof(float) * size);
    for (int i = 0; i < size; i++)
    {
        arr[i] = (float)-1;
    }
    return arr;
}

float compare_patches(int i, int j, float *image, float *gaussian_arr, int pixels, int padding, int patch)
{
    float comp = 0;
    for (int m = 0; m < patch; m++)
    {
        for (int n = 0; n < patch; n++)
        {
            int idx_1 = i + (m - padding) * (pixels + 2 * padding) + n - padding;
            int idx_2 = j + (m - padding) * (pixels + 2 * padding) + n - padding;

            if ((image[idx_1] != (float)-1) && (image[idx_2] != (float)-1))
            {
                float diff = image[idx_1] - image[idx_2];
                comp += gaussian_arr[m * pixels + n] * (diff * diff);
            }
        }
    }
    return comp;
}

float *gaussian_filter(int patch)
{
    float *gaussian_arr = allocate_mem(patch * patch);

    int padding = patch / 2;
    for (int i = -padding; i <= padding; i++)
    {
        for (int j = -padding; j <= padding; j++)
        {
            int index = (i + padding) * patch + (j + padding);
            gaussian_arr[index] = exp(-(float)(i * i + j * j) / (float)(2 * PATCH_SIGMA * PATCH_SIGMA)) / (float)(2 * M_PI * PATCH_SIGMA * PATCH_SIGMA);
        }
    }
    return gaussian_arr;
}