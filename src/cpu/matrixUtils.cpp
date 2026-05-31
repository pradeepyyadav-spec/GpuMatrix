#include "../../include/matrixUtils.hpp"

#include <iostream>
#include <random>

Matrix createIdentityMatrix(int matrixSize)
{
    Matrix matrix( matrixSize * matrixSize, 0.0 );

    for(int row = 0; row < matrixSize; row++ )
    {
        matrix[row * matrixSize + row] = 1.0;
    }

    return matrix;
}

Matrix createEdaDenseMatrix(int matrixSize)
{
    Matrix matrix( matrixSize * matrixSize, 0.0f );

    for( int row = 0; row < matrixSize; row++ )
    {
        for( int col = 0; col < matrixSize; col++ )
        {
            if( row == col )
            {
                matrix[row * matrixSize + col] = 1000.0;
            }
            else if( std::abs( row - col ) <= 5 )
            {
                matrix[row * matrixSize + col] = 0.01;
            }
            else
            {
                matrix[row * matrixSize + col] = 0.0;
            }
        }
    }

    return matrix;
}
