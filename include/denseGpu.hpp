#pragma once

#include "denseMatrix.hpp"

class DenseGpu
{
public:
    static DenseMatrix matrixMultiplyNaive( const DenseMatrix& matrixA, const DenseMatrix& matrixB );
    static DenseMatrix matrixMultiplyTiled( const DenseMatrix& matrixA, const DenseMatrix& matrixB );
    static DenseMatrix matrixPowerTiled( const DenseMatrix& inputMatrix, int exponentValue );
    static double getLastKernelRuntimeMs()
    {
        return lastKernelRuntimeMs_;
    }
    static double getAccumulatedKernelRuntimeMs()
    {
        return accumulatedKernelRuntimeMs_;
    }
    static void resetAccumulatedKernelRuntime()
    {   
        accumulatedKernelRuntimeMs_ = 0.0;
    }
    static DenseMatrix matrixPowerPersistent( const DenseMatrix& inputMatrix, int exponentValue );

    static double lastKernelRuntimeMs_;
    static double accumulatedKernelRuntimeMs_;
};
