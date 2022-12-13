#!/usr/bin/env bash


#SBATCH -p wacc
#SBATCH -J nlm_cuda
#SBATCH -o nlm_cuda.out -e nlm_cuda.err
#SBATCH --gres=gpu:1

make clean
module load nvidia/cuda
nvcc nlm_cuda.cu nlm.cu utils.cpp -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std=c++17 -o nlm_cuda
./nlm_cuda 64 3 noisy_image.txt