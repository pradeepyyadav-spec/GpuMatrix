#pragma once
#include <vector>

using Matrix = std::vector<float>;

Matrix createIdentityMatrix( int matrixSize );

Matrix createEdaDenseMatrix( int matrixSize );

void printMatrixSummary( const Matrix& matrix, int matrixSize );
