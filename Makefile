CXX = g++
NVCC = nvcc

INCLUDE_DIR = include

CPP_FLAGS = -O3 -std=c++17 -Wall -Wextra -I$(INCLUDE_DIR)
CUDA_FLAGS = -O3

TARGETS = \
	benchmarkInfo \
	environmentCheck \
	cpuExponentiationBenchmark

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

cpuExponentiationBenchmark:
	$(CXX) \
	$(CPP_FLAGS) \
	src/cpu/denseCpu.cpp \
	src/cpu/cpuExponentiationBenchmark.cpp \
	-o cpuExponentiationBenchmark

clean:
	rm -f $(TARGETS)

rebuild: clean all

.PHONY: all clean rebuild
