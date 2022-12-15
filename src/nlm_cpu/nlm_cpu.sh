#!/usr/bin/env bash

#SBATCH -p wacc
#SBATCH -J nlm_cpu
#SBATCH -o nlm_cpu.out -e nlm_cpu.err

g++ nlm_cpu.cpp utils.cpp -Wall -O -std=c++17 -o nlm_cpu
./nlm_cpu 256 3 noisy_image.txt