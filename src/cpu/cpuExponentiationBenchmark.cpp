#include "../../include/timer.hpp"
#include "../../include/denseCpu.hpp"
#include "../../include/matrixGenerator.hpp"

#include <iostream>

int main()
{
    constexpr int matrixSize = 512;
    constexpr int exponentValue = 100;

    std::cout << "Generating Matrix..." << std::endl;

    DenseMatrix matrix = MatrixGenerator::createEdaDenseMatrix( matrixSize );

    Timer timer;

    timer.start();

    DenseMatrix result = DenseCpu::matrixPower( matrix, exponentValue );

    double executionTime = timer.stop();

    std::cout << "CPU Runtime: " << executionTime << " sec" << std::endl;

    return 0;
}
