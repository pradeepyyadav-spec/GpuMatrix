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
    void copyFromHost( const float* hostData );
    void copyToHost( float* hostData );
    void setToIdentity();
    DeviceMatrix( const DeviceMatrix&) = delete;
    DeviceMatrix& operator=( const DeviceMatrix&) = delete;
    DeviceMatrix( DeviceMatrix&& other) noexcept;
    DeviceMatrix& operator=( DeviceMatrix&& other) noexcept;
    void swap( DeviceMatrix& other) noexcept;

private:
    int matrixSize_;
    float* deviceData_;
};
