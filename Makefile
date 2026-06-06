CXX = g++
NVCC = nvcc

INCLUDE_DIR = include

CPP_FLAGS = -O3 -std=c++17 -Wall -Wextra -I$(INCLUDE_DIR)
CUDA_FLAGS = -O3

TARGETS = \
	benchmarkInfo \
	environmentCheck \
        gpuMatrixMultiplyBenchmark \
        exponentiationBenchmark

all: $(TARGETS)

benchmarkInfo:
	$(CXX) \
	$(CPP_FLAGS) \
	src/benchmark/benchmarkInfo.cpp \
	-o benchmarkInfo

environmentCheck:
	$(NVCC) \
	$(CUDA_FLAGS) \
	src/environment/environmentCheck.cu \
	-o environmentCheck

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
