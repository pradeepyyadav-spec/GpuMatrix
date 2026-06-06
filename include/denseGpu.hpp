#pragma once

#include "denseMatrix.hpp"

class DenseGpu
{
public:

    static DenseMatrix matrixMultiplyNaive( const DenseMatrix& matrixA, const DenseMatrix& matrixB );
    static DenseMatrix matrixMultiplyTiled( const DenseMatrix& matrixA, const DenseMatrix& matrixB );
};
