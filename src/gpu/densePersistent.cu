#include "../../include/denseGpu.hpp"
#include "../../include/deviceMatrix.hpp"
#include "../../include/gpuKernels.cuh"
#include "../../include/cudaTimer.hpp"

#include <cassert>

namespace
{
    constexpr int tileSize = 16;
}

static void launchTiledMultiply( DeviceMatrix& matrixA, DeviceMatrix& matrixB, DeviceMatrix& matrixC )
{
    dim3 threadsPerBlock( tileSize, tileSize );
    dim3 blocksPerGrid( ( matrixA.getMatrixSize() + tileSize - 1) / tileSize, ( matrixA.getMatrixSize() + tileSize - 1) / tileSize );

    CudaTimer kernelTimer;
    kernelTimer.start();

    cudaMemset( matrixC.getData(), 0, matrixC.getSizeInBytes() );
    tiledMatrixMultiplyKernel<<< blocksPerGrid, threadsPerBlock >>>( matrixA.getData(), matrixB.getData(), matrixC.getData(), matrixA.getMatrixSize() );

    cudaDeviceSynchronize();
    double kernelRuntime = kernelTimer.stop();
    DenseGpu::accumulatedKernelRuntimeMs_ += kernelRuntime;
}

DenseMatrix DenseGpu::matrixPowerPersistent( const DenseMatrix& inputMatrix, int exponentValue )
{
    assert( inputMatrix.isSquare() );

    int matrixSize = inputMatrix.getRowCount();
    DeviceMatrix baseMatrix( matrixSize );
    DeviceMatrix resultMatrix( matrixSize );
    DeviceMatrix tempMatrix( matrixSize );
    baseMatrix.copyFromHost( inputMatrix.getRawData() );
    resultMatrix.setToIdentity();

    while ( exponentValue > 0 )
    {
        if ( exponentValue & 1 )
        {
            launchTiledMultiply( resultMatrix, baseMatrix, tempMatrix );
            resultMatrix.swap( tempMatrix );
        }

        launchTiledMultiply( baseMatrix, baseMatrix, tempMatrix );
        baseMatrix.swap( tempMatrix );
        exponentValue >>= 1;
    }

    DenseMatrix result( matrixSize, matrixSize );
    resultMatrix.copyToHost( result.getRawData() );

    return result;
}
