#ifndef NLM_CUH
#define NLM_CUH

__global__ void nlm_sm(float *nlm_image, float *image, int size_with_padding, float *gaussian_arr, int pixels, int padding, int patch);
__device__ void compare_patches(float *comp, float *image, float *gaussian_arr, int i, int j, int pixels, int padding, int patch);

#endif
