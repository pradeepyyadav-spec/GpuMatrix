NVCC = nvcc
CXX = g++

CUDA_FLAGS = -O3
CPP_FLAGS = -O3

all:

	$(NVCC) \
	src/environment/environmentCheck.cu \
	-o environmentCheck

	$(CXX) \
	src/benchmark/benchmarkInfo.cpp \
	-o benchmarkInfo

	$(CXX) \
	src/cpu/matrixUtils.cpp \
	src/cpu/denseCpu.cpp \
	src/cpu/cpuExponentiationBenchmark.cpp \
	-o cpuExponentiationBenchmark \
	$(CPP_FLAGS)

clean:

	rm -f environmentCheck
	rm -f benchmarkInfo
