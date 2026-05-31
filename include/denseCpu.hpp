#pragma once
#include "denseMatrix.hpp"

class DenseCpu
{
public:

    static DenseMatrix matrixMultiply( const DenseMatrix& matrixA, const DenseMatrix& matrixB );
    static DenseMatrix matrixPower( const DenseMatrix& inputMatrix, int exponentValue );
};
