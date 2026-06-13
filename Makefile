CXX = g++
NVCC = nvcc

LARGE_MAT ?= 0 


INCLUDE_DIR = include

CPP_FLAGS = -O3 -std=c++17 -Wall -Wextra -I$(INCLUDE_DIR)
CUDA_FLAGS = -O3

ifeq ($(LARGE_MAT),1)
    CUDA_FLAGS += -DLARGE_MAT
endif

TARGETS = \
        gpuMatrixMultiplyBenchmark \
        exponentiationBenchmark \
        profilingBenchmark

all: $(TARGETS)

gpuMatrixMultiplyBenchmark:
	$(NVCC) \
	$(CUDA_FLAGS) \
	-I$(INCLUDE_DIR) \
	src/gpu/denseNaive.cu \
	src/gpu/denseTiled.cu \
	src/cpu/denseCpu.cpp \
	src/benchmark/gpuMatrixMultiplyBenchmark.cu \
	-o gpuMatrixMultiplyBenchmark

exponentiationBenchmark:
	$(NVCC) $(CUDA_FLAGS) -Iinclude \
	src/cpu/denseCpu.cpp \
	src/gpu/denseNaive.cu \
	src/gpu/denseTiled.cu \
	src/gpu/densePersistent.cu \
	src/gpu/deviceMatrix.cu \
	src/benchmark/exponentiationBenchmark.cu \
	-o exponentiationBenchmark

profilingBenchmark:
	$(NVCC) $(CUDA_FLAGS) -Iinclude \
	src/cpu/denseCpu.cpp \
	src/gpu/denseNaive.cu \
	src/gpu/denseTiled.cu \
	src/gpu/densePersistent.cu \
	src/gpu/deviceMatrix.cu \
	src/benchmark/profilingBenchmark.cu \
	-o profilingBenchmark
clean:
	rm -f $(TARGETS)

rebuild: clean all

.PHONY: all clean rebuild
