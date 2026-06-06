#pragma once
#include <cmath>
#include "denseMatrix.hpp"
#include <random>

class MatrixGenerator
{
public:
    static DenseMatrix createIdentityMatrix( int matrixSize )
    {
        DenseMatrix matrix( matrixSize, matrixSize);

        for ( int row = 0; row < matrixSize; row++ )
        {
            matrix.setValue( row, row, 1.0 );
        }

        return matrix;
    }

    static DenseMatrix createEdaDenseMatrix( int matrixSize )
    {
        DenseMatrix matrix( matrixSize, matrixSize );

        for ( int row = 0; row < matrixSize; row++ )
        {
            for ( int column = 0; column < matrixSize; column++ )
            {
                if (row == column)
                {
                    matrix.setValue( row, column, 1.001 );
                }
                else if ( std::abs( row - column) <= 5 )
                {
                    matrix.setValue( row, column, 0.001 );
                }
                else
                {
                    matrix.setValue( row, column, 0.0 );
                }
            }
        }

        return matrix;
    }

    static DenseMatrix createRandomDenseMatrix( int matrixSize )
    {
        DenseMatrix matrix( matrixSize, matrixSize );
        std::mt19937 generator(42);
        std::uniform_real_distribution<float> distribution( 0.98, 1.98);

        for ( int row = 0; row < matrixSize; row++ )
        {
            for ( int column = 0; column < matrixSize; column++ )
            {
                matrix.setValue( row, column, distribution(generator) );
            }
        }
        return matrix;
    }
};
