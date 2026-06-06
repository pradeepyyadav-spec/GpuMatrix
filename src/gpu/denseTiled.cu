#include "../../include/denseGpu.hpp"

#include <cuda_runtime.h>

namespace
{
    constexpr int tileSize = 16;
}

__global__ void tiledMatrixMultiplyKernel( const float* matrixA, const float* matrixB, float* matrixC, int matrixSize )
{
    __shared__ float tileA[tileSize][tileSize];
    __shared__ float tileB[tileSize][tileSize];

    const int row = blockIdx.y * tileSize + threadIdx.y;
    const int column = blockIdx.x * tileSize + threadIdx.x;

    float sum = 0.0;

    for ( int tileIndex = 0; tileIndex < (matrixSize + tileSize - 1) / tileSize; tileIndex++ )
    {
        const int aColumn = tileIndex * tileSize + threadIdx.x;
        const int bRow = tileIndex * tileSize + threadIdx.y;

        if ( row < matrixSize && aColumn < matrixSize )
        {
            tileA[threadIdx.y][threadIdx.x] = matrixA[ row * matrixSize + aColumn ];
        }
        else
        {
            tileA[threadIdx.y][threadIdx.x] = 0.0;
        }

        if ( bRow < matrixSize && column < matrixSize )
        {
            tileB[threadIdx.y][threadIdx.x] = matrixB[ bRow * matrixSize + column ];
        }
        else
        {
            tileB[threadIdx.y][threadIdx.x] = 0.0;
        }

        __syncthreads();

        for ( int k = 0; k < tileSize; k++ )
        {
            sum += tileA[threadIdx.y][k] * tileB[k][threadIdx.x];
        }

        __syncthreads();
    }

    if ( row < matrixSize && column < matrixSize )
    {
        matrixC[ row * matrixSize + column ] = sum;
    }
}

DenseMatrix DenseGpu::matrixMultiplyTiled( const DenseMatrix& matrixA, const DenseMatrix& matrixB )
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

    dim3 threadsPerBlock( tileSize, tileSize );
    dim3 blocksPerGrid( (matrixSize + tileSize - 1) / tileSize, (matrixSize + tileSize - 1) / tileSize );

    tiledMatrixMultiplyKernel<<< blocksPerGrid, threadsPerBlock >>>( deviceMatrixA, deviceMatrixB, deviceMatrixC, matrixSize );

    cudaDeviceSynchronize();

    cudaMemcpy( result.getRawData(), deviceMatrixC, result.getSizeInBytes(), cudaMemcpyDeviceToHost );

    cudaFree(deviceMatrixA);
    cudaFree(deviceMatrixB);
    cudaFree(deviceMatrixC);

    return result;
}
