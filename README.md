# CS759-Fall-22
Repository for HPC project Fall 22


# Folder and steps for execution

`/src/` folder contains all utility scripts, bash scripts, kernel code, timing code required to denoise the image and performance evaluation

# NLM (Non Local Means) CPU Implementation

`/src/nlm_cpu/` folder contains code for cpu implementation of NLM image denoising algorithm

`sbatch /src/nlm_cpu/nlm_cpu.sh` to execute

# NLM (Non Local Means) CUDA Implementation

`/src/nlm_cuda/` folder contains code for cuda implementation of NLM image denoising algorithm

`sbatch /src/nlm_cpu/nlm_cuda.sh` to execute

# NLM (Non Local Means) CUDA Shared Memory Implementation

`/src/nlm_cuda_sm/` folder contains code for cuda implementation of NLM image denoising algorithm using Shared Memory (SM)

`sbatch /src/nlm_cpu/nlm_cuda_sm.sh` to execute

# kNN (k Nearest Neighbors) CPU Implementation

`/src/knn_cpu/` folder contains code for cpu implementation of kNN image denoising algorithm

`sbatch /src/nlm_cpu/knn_cpu.sh` to execute

# kNN (k Nearest Neighbors) CUDA Implementation

`/src/knn_cuda/` folder contains code for cpu implementation of kNN image denoising algorithm

`sbatch /src/nlm_cpu/knn_cuda.sh` to execute

# Execution

Each folder in `/src/` folder has shell scripts to produce filtered_image.txt file


# Implementation of Image Denoising Algorithms using CUDA

As part of the Final Project for CS 759 High Performance Computing, I implemented two popular image denoising algorithms in CUDA

   1. Non Local Means (NLM) 
   2. k Nearest Neighbors (kNN)

For each algorithm, I implemented three variants for performance evaluation
   1. CPU Implementation
   2. CUDA Implementation (Unoptimized)
   3. Optimized Implementation (Shared memmory, reduce memory access etc.,)

I evaluated the NLM and kNN algorithms for images of different resolution and different patch size. The current code only supports grayscale, RGB also should similar performance characteristics since, we apply same technique for each of RGB components of coloured pixels.  

# Preprocessing and Postprocessing Matlab scripts

`/processing/` contains the matlab scripts to convert given RGB/grayscale image to pixels values, add gaussian noise and creates file names noisy_image.txt

`/read.m/` converts given RGB/grayscale image to grayscale image and logs pixel values to noisy_image.txt

`/write.m/` converts filtered_image.txt to grayscale image


# Data & Results

`/images/` contains the images of different resolution for experiments and performance evaluation

`/results_images/` contains the denoised images of different resolution for experiments

`/images_txt/` contains the pixels values of *.png file images folder









