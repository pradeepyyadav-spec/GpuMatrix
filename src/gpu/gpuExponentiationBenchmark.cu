#include "../../include/denseCpu.hpp"
#include "../../include/denseGpu.hpp"
#include "../../include/matrixGenerator.hpp"
#include "../../include/timer.hpp"

#include <iostream>
#include <iomanip>
#include <cmath>

bool validateResults( const DenseMatrix& cpuResult, const DenseMatrix& gpuResult )
{
    constexpr float tolerance = 1e-2;
    const float* cpuData = cpuResult.getRawData();
    const float* gpuData = gpuResult.getRawData();

    for ( size_t index = 0; index < cpuResult.getElementCount(); index++ )
    {
        if ( std::abs( cpuData[index] - gpuData[index]) > tolerance )
        {
            return false;
        }
    }

    return true;
}

int main()
{
    constexpr int matrixSize = 1024;
    constexpr int exponentValue = 100;

    DenseMatrix matrix = MatrixGenerator::createEdaDenseMatrix( matrixSize );

    std::cout << "=============================================\n";
    std::cout << "CPU vs GPU Matrix Exponentiation\n";
    std::cout << "Matrix Size : " << matrixSize << " x " << matrixSize << "\n";
    std::cout << "Exponent : " << exponentValue << "\n";
    std::cout << "=============================================\n";

    Timer cpuTimer;
    cpuTimer.start();

    DenseMatrix cpuResult = DenseCpu::matrixPower( matrix, exponentValue );

    double cpuTime = cpuTimer.stop();

    Timer gpuTimer;
    gpuTimer.start();

    DenseMatrix gpuResult = DenseGpu::matrixPowerTiled( matrix, exponentValue );

    double gpuTime = gpuTimer.stop();

    bool validationPassed = validateResults( cpuResult, gpuResult );

    std::cout << "\n=========================================================\n";
    std::cout << std::left << std::setw(20) << "Configuration" << std::setw(15) << "Runtime(sec)" << std::setw(15)
              << "Speedup" << std::setw(15) << "Validation" << "\n";
    std::cout << "=========================================================\n";

    std::cout << std::left << std::setw(20) << "CPU Exponentiation" << std::setw(15) << cpuTime << std::setw(15) << "1.0" << std::setw(15) << "-" << "\n";
    std::cout << std::left << std::setw(20) << "GPU Exponentiation" << std::setw(15) << gpuTime << std::setw(15)
              << cpuTime / gpuTime << std::setw(15) << ( validationPassed ? "PASS" : "FAIL") << "\n";

    std::cout << "=========================================================\n";

    return 0;
}
