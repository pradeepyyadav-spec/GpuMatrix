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

clean:

	rm -f environmentCheck
	rm -f benchmarkInfo
