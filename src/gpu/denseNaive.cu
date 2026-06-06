#include "../../include/denseGpu.hpp"
#include "../../include/cudaTimer.hpp"
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

DenseMatrix DenseGpu::matrixMultiplyNaive( const DenseMatrix& matrixA, const DenseMatrix& matrixB )
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

    CudaTimer kernelTimer;
    kernelTimer.start();

    matrixMultiplyKernel<<< blocksPerGrid, threadsPerBlock >>>( deviceMatrixA, deviceMatrixB, deviceMatrixC, matrixSize );
    cudaDeviceSynchronize();

    double kernelRuntime = kernelTimer.stop();
    DenseGpu::lastKernelRuntime_ = kernelRuntime;
    DenseGpu::accumulatedKernelRuntimeMs_ += kernelRuntime;

    cudaMemcpy( result.getRawData(), deviceMatrixC, result.getSizeInBytes(), cudaMemcpyDeviceToHost );

    cudaFree(deviceMatrixA);
    cudaFree(deviceMatrixB);
    cudaFree(deviceMatrixC);

    return result;
}

DenseMatrix DenseGpu::matrixPowerNaive( const DenseMatrix& inputMatrix, int exponentValue )
{
    if ( !inputMatrix.isSquare() )
    {
        throw std::runtime_error( "Matrix exponentiation requires square matrix." );
    }

    DenseMatrix result( inputMatrix.getRowCount(), inputMatrix.getColumnCount() );
    for ( int row = 0; row < result.getRowCount(); row++ )
    {
        result.setValue( row, row, 1.0 );
    }

    DenseMatrix baseMatrix = inputMatrix;
    while ( exponentValue > 0 )
    {
        if ( exponentValue & 1 )
        {
            result = matrixMultiplyNaive( result, baseMatrix );
        }
        baseMatrix = matrixMultiplyNaive( baseMatrix, baseMatrix );
        exponentValue >>= 1;
    }
    return result;
}
