#include "../../include/deviceMatrix.hpp"
#include <vector>
#include <algorithm>
#include <utility>


DeviceMatrix::DeviceMatrix( int matrixSize) :
    matrixSize_( matrixSize )
{
    cudaMalloc( &deviceData_, getSizeInBytes() );
}

DeviceMatrix::DeviceMatrix( DeviceMatrix&& other) noexcept :
    matrixSize_( other.matrixSize_ ), deviceData_( other.deviceData_ )
{
    other.matrixSize_ = 0;
    other.deviceData_ = nullptr;
}

DeviceMatrix::~DeviceMatrix()
{
    if ( deviceData_ != nullptr )
    {
        cudaFree( deviceData_ );
    }
}

DeviceMatrix& DeviceMatrix::operator=( DeviceMatrix&& other ) noexcept
{
    if ( this != &other )
    {
        if ( deviceData_ != nullptr )
        {
            cudaFree( deviceData_ );
        }
        matrixSize_ = other.matrixSize_;
        deviceData_ = other.deviceData_;
        other.matrixSize_ = 0;
        other.deviceData_ = nullptr;
    }
    return *this;
}

void DeviceMatrix::swap( DeviceMatrix& other ) noexcept
{
    std::swap( matrixSize_, other.matrixSize_ );
    std::swap( deviceData_, other.deviceData_ );
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

void DeviceMatrix::copyFromHost( const float* hostData )
{
    cudaMemcpy( deviceData_, hostData, getSizeInBytes(), cudaMemcpyHostToDevice );
}

void DeviceMatrix::copyToHost( float* hostData )
{
    cudaMemcpy( hostData, deviceData_, getSizeInBytes(), cudaMemcpyDeviceToHost );
}

void DeviceMatrix::setToIdentity()
{
    std::vector<float> identityData( matrixSize_ * matrixSize_, 0.0 );

    for ( int index = 0; index < matrixSize_; index++ )
    {
        identityData[ index * matrixSize_ + index ] = 1.0;
    }
    copyFromHost( identityData.data() );
}
