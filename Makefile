CXX = g++
NVCC = nvcc

TILE_SIZE ?= 16
USE_FAST_MATH ?= 0
ENABLE_UNROLL ?= 0
USE_BUILDARCH ?= 0
LARGE_MAT ?= 0 


INCLUDE_DIR = include

CPP_FLAGS = -O3 -std=c++17 -Wall -Wextra -I$(INCLUDE_DIR)
CUDA_FLAGS = -O3

CUDA_FLAGS += -DTILE_SIZE=$(TILE_SIZE)

ifeq ($(ENABLE_UNROLL),1)
    CUDA_FLAGS += -DENABLE_UNROLL
endif

ifeq ($(USE_FAST_MATH),1)
    CUDA_FLAGS += --use_fast_math
endif

ifeq ($(USE_BUILDARCH),1)
    CUDA_FLAGS += -gencode arch=compute_75,code=sm_75
endif

ifeq ($(LARGE_MAT),1)
    CUDA_FLAGS += -DLARGE_MAT
endif

printConfig:
	@echo "Tile Size      = $(TILE_SIZE)"
	@echo "Fast Math      = $(USE_FAST_MATH)"
	@echo "Loop Unrolling = $(ENABLE_UNROLL)"

TARGETS = \
        gpuMatrixMultiplyBenchmark \
        exponentiationBenchmark

all: $(TARGETS)

gpuMatrixMultiplyBenchmark:
	$(NVCC) \
	$(CUDA_FLAGS) \
	-I$(INCLUDE_DIR) \
	src/gpu/denseNaive.cu \
	src/gpu/denseTiled.cu \
	src/cpu/denseCpu.cpp \
	src/gpu/gpuMatrixMultiplyBenchmark.cu \
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

clean:
	rm -f $(TARGETS)

rebuild: clean all

.PHONY: all clean rebuild
