#!/usr/bin/env bash


#SBATCH -p wacc
#SBATCH -J knn_cuda
#SBATCH -o knn_cuda.out -e knn_cuda.err
#SBATCH --gres=gpu:1

module load nvidia/cuda
nvcc knn_cuda.cu knn.cu utils.cpp -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std=c++17 -o knn_cuda
./knn_cuda 256 3 noisy_image.txt