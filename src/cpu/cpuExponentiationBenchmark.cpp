#include "../../include/timer.hpp"
#include "../../include/matrixUtils.hpp"

#include <iostream>

Matrix matrixPowerCpu( const Matrix&, int, int );

int main()
{
    constexpr int matrixSize = 512;
    constexpr int exponentValue = 100;

    std::cout << "Generating Matrix..." << std::endl;

    Matrix matrix = createEdaDenseMatrix( matrixSize );

    Timer timer;

    timer.start();

    Matrix result = matrixPowerCpu( matrix, exponentValue, matrixSize );

    double executionTime = timer.stop();

    std::cout << "CPU Runtime: " << executionTime << " sec" << std::endl;

    return 0;
}
