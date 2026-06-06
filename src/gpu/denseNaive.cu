#include "../../include/denseGpu.hpp"

#include <cuda_runtime.h>

__global__ void matrixMultiplyKernel( const float* matrixA, const float* matrixB, float* matrixC, int matrixSize )
{
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int column = blockIdx.x * blockDim.x + threadIdx.x;

    if ( row >= matrixSize || column >= matrixSize )
    {
        return;
    }

    float sum = 0.0f;
    for ( int k = 0; k < matrixSize; k++ )
    {
        sum += matrixA[row * matrixSize + k] * matrixB[k * matrixSize + column];
    }

    matrixC[ row * matrixSize + column ] = sum;
}

DenseMatrix DenseGpu::matrixMultiply( const DenseMatrix& matrixA, const DenseMatrix& matrixB )
{
    const int matrixSize = matrixA.getRowCount();

    DenseMatrix result( matrixSize, matrixSize );

    float* deviceMatrixA = nullptr;
    float* deviceMatrixB = nullptr;
    float* deviceMatrixC = nullptr;

    cudaMalloc( &deviceMatrixA, matrixA.getSizeInBytes() );
    cudaMalloc( &deviceMatrixB, matrixB.getSizeInBytes() );
    cudaMalloc( &deviceMatrixC, result.getSizeInBytes() );

    cudaMemcpy( deviceMatrixA, matrixA.getRawData(), matrixA.getSizeInBytes(), cudaMemcpyHostToDevice );
    cudaMemcpy( deviceMatrixB, matrixB.getRawData(), matrixB.getSizeInBytes(), cudaMemcpyHostToDevice );

    dim3 threadsPerBlock( 16, 16 );
    dim3 blocksPerGrid( (matrixSize + 15) / 16, (matrixSize + 15) / 16 );

    matrixMultiplyKernel<<< blocksPerGrid, threadsPerBlock >>>( deviceMatrixA, deviceMatrixB, deviceMatrixC, matrixSize );

    cudaDeviceSynchronize();

    cudaMemcpy( result.getRawData(), deviceMatrixC, result.getSizeInBytes(), cudaMemcpyDeviceToHost );

    cudaFree(deviceMatrixA);
    cudaFree(deviceMatrixB);
    cudaFree(deviceMatrixC);

    return result;
}
