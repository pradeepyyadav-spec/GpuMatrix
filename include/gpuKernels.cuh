#pragma once

__global__ void tiledMatrixMultiplyKernel( const float* matrixA, const float* matrixB, float* matrixC, int matrixSize );
