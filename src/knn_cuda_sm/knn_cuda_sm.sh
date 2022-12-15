#!/usr/bin/env bash


#SBATCH -p wacc
#SBATCH -J knn_cuda_sm
#SBATCH -o knn_cuda_sm.out -e knn_cuda_sm.err
#SBATCH --gres=gpu:1

module load nvidia/cuda
nvcc knn_cuda_sm.cu knn.cu utils.cpp -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std=c++17 -o knn_cuda_sm
./knn_cuda_sm 64 3 noisy_image.txt