#include "../../include/denseCpu.hpp"
#include "../../include/denseGpu.hpp"
#include "../../include/matrixGenerator.hpp"
#include "../../include/timer.hpp"

#include <iostream>
#include <iomanip>

int main()
{
    constexpr int matrixSize = 1024;

    DenseMatrix matrixA = MatrixGenerator::createEdaDenseMatrix( matrixSize );

    DenseMatrix matrixB = MatrixGenerator::createEdaDenseMatrix( matrixSize );

    std::cout << "=============================================\n";
    std::cout << "CPU vs GPU Matrix Multiplication\n";
    std::cout << "Matrix Size : " << matrixSize << " x " << matrixSize << "\n";
    std::cout << "=============================================\n";

    Timer cpuTimer;
    cpuTimer.start();

    DenseMatrix cpuResult = DenseCpu::matrixMultiply( matrixA, matrixB );

    double cpuTime = cpuTimer.stop();

    Timer gpuTimer;
    gpuTimer.start();

    DenseMatrix gpuResult = DenseGpu::matrixMultiply( matrixA, matrixB );

    double gpuTime = gpuTimer.stop();

    std::cout << std::fixed << std::setprecision(4);
    std::cout << "CPU Time : " << cpuTime << " sec\n";
    std::cout << "GPU Time : " << gpuTime << " sec\n";
    std::cout << "Speedup : " << cpuTime / gpuTime << "x\n";

    return 0;
}
