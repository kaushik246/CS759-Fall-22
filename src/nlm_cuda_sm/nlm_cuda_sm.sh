#!/usr/bin/env bash


#SBATCH -p wacc
#SBATCH -J nlm_cuda_sm
#SBATCH -o nlm_cuda_sm.out -e nlm_cuda_sm.err
#SBATCH --gres=gpu:1

module load nvidia/cuda
nvcc nlm_cuda_sm.cu nlm_sm.cu utils.cpp -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std=c++17 -o nlm_cuda_sm
./nlm_cuda_sm 64 3 noisy_image.txt