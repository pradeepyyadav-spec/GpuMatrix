#include "../../include/denseCpu.hpp"
#include "../../include/matrixGenerator.hpp"
#include <stdexcept>

DenseMatrix DenseCpu::matrixMultiply( const DenseMatrix& matrixA, const DenseMatrix& matrixB )
{
    const int matrixSize = matrixA.getRowCount();

    DenseMatrix result( matrixSize, matrixSize );

    for ( int row = 0; row < matrixSize; row++ )
    {
        for ( int column = 0; column < matrixSize; column++ )
        {
            float sum = 0.0f;

            for ( int k = 0; k < matrixSize; k++ )
            {
                sum += matrixA.getValue(row, k) * matrixB.getValue(k, column);
            }

            result.setValue( row, column, sum );
        }
    }

    return result;
}

DenseMatrix DenseCpu::matrixPower( const DenseMatrix& inputMatrix, int exponentValue )
{
    if (!inputMatrix.isSquare())
    {
        throw std::runtime_error( "Matrix exponentiation requires a square matrix." );
    }

    DenseMatrix result = MatrixGenerator::createIdentityMatrix( inputMatrix.getRowCount() );

    DenseMatrix baseMatrix = inputMatrix;

    while (exponentValue > 0)
    {
        if (exponentValue & 1)
        {
            result = matrixMultiply( result, baseMatrix );
        }

        baseMatrix = matrixMultiply( baseMatrix, baseMatrix );

        exponentValue >>= 1;
    }

    return result;
}
