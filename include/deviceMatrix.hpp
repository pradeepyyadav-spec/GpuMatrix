#pragma once
#include <cuda_runtime.h>

class DeviceMatrix
{
public:
    DeviceMatrix( int matrixSize );
    ~DeviceMatrix();
    float* getData();
    int getMatrixSize() const;
    size_t getSizeInBytes() const;

private:
    int matrixSize_;
    float* deviceData_;
};
