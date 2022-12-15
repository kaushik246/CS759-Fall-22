#!/usr/bin/env bash

#SBATCH -p wacc
#SBATCH -J knn_cpu
#SBATCH -o knn_cpu.out -e knn_cpu.err

make clean
g++ knn_cpu.cpp utils.cpp -Wall -O -std=c++17 -o knn_cpu
./knn_cpu 64 3 noisy_image.txt