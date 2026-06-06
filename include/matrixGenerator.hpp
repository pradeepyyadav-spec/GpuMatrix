#pragma once
#include <cmath>
#include "denseMatrix.hpp"

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
                    matrix.setValue( row, column, 1000.0 );
                }
                else if ( std::abs( row - column) <= 5 )
                {
                    matrix.setValue( row, column, 0.01 );
                }
                else
                {
                    matrix.setValue( row, column, 0.0 );
                }
            }
        }

        return matrix;
    }

    static DenseMatrix createRandomDenseMatrix( int matrixSize, float value )
    {
        DenseMatrix matrix( matrixSize, matrixSize );

        for ( int row = 0; row < matrixSize; row++ )
        {
            for ( int column = 0; column < matrixSize; column++ )
            {
                matrix.setValue( row, column, value );
            }
        }
        return matrix;
    }
};
