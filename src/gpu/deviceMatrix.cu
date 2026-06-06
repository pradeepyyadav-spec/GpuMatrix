#include "../../include/deviceMatrix.hpp"

DeviceMatrix::DeviceMatrix( int matrixSize) :
    matrixSize_( matrixSize )
{
    cudaMalloc( &deviceData_, getSizeInBytes() );
}

DeviceMatrix::~DeviceMatrix()
{
    cudaFree( deviceData_ );
}

float* DeviceMatrix::getData()
{
    return deviceData_;
}

int DeviceMatrix::getMatrixSize() const
{
    return matrixSize_;
}

size_t DeviceMatrix::getSizeInBytes() const
{
    return static_cast<size_t>( matrixSize_ ) * matrixSize_ * sizeof( float );
}
