#ifndef KNN_CUH
#define KNN_CUH

__global__ void knn_sm(float *knn_image, float *image, int size_with_padding, float *gaussian_arr, int pixels, int padding, int patch);
__device__ void compare_patches(float *comp, float *image, float *gaussian_arr, int i, int j, int pixels, int padding, int patch);

#endif
