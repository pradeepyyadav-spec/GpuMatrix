Matrix matrixMultiplyCpu( const Matrix& matrixA, const Matrix& matrixB, int matrixSize )
{
    Matrix result( matrixSize * matrixSize, 0.0f );

    for( int row = 0; row < matrixSize; row++ )
    {
        for(int col = 0; col < matrixSize; col++ )
        {
            float sum = 0.0;

            for( int k = 0; k < matrixSize; k++ )
            {
                sum += matrixA[row * matrixSize + k] * matrixB[k * matrixSize + col];
            }

            result[row * matrixSize + col] = sum;
        }
    }

    return result;
}

Matrix matrixPowerCpu( const Matrix& inputMatrix, int exponentValue, int matrixSize )
{
    Matrix result = createIdentityMatrix( matrixSize );

    Matrix baseMatrix = inputMatrix;

    while(exponentValue > 0)
    {
        if(exponentValue & 1)
        {
            result = matrixMultiplyCpu( result, baseMatrix, matrixSize );
        }

        baseMatrix = matrixMultiplyCpu( baseMatrix, baseMatrix, matrixSize );

        exponentValue >>= 1;
    }

    return result;
}
