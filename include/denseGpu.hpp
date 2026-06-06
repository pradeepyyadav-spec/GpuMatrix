#pragma once

#include "denseMatrix.hpp"

class DenseGpu
{
public:

    static DenseMatrix matrixMultiply( const DenseMatrix& matrixA, const DenseMatrix& matrixB );
};
