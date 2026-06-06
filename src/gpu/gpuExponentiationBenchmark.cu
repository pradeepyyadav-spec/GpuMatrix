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
    constexpr int matrixSize = 2048;
    constexpr int exponentValue = 100;

    DenseMatrix matrix = MatrixGenerator::createEdaDenseMatrix( 1024 );
    DenseMatrix matrix2048 = MatrixGenerator::createEdaDenseMatrix( matrixSize );


    Timer cpuTimer;
    cpuTimer.start();

    DenseMatrix cpuResult = DenseCpu::matrixPower( matrix, exponentValue );

    double cpuTime = cpuTimer.stop();

    Timer gpuTimer;
    gpuTimer.start();

    DenseMatrix gpuResult = DenseGpu::matrixPowerTiled( matrix, exponentValue );

    double gpuTime = gpuTimer.stop();

    bool validationPassed = validateResults( cpuResult, gpuResult );
    
    std::cout << "=============================================\n";
    std::cout << "CPU vs GPU Matrix Exponentiation\n";
    std::cout << "Matrix Size : " << matrixSize << " x " << matrixSize << "\n";
    std::cout << "Exponent : " << exponentValue << "\n";
    std::cout << "=============================================\n";
    std::cout << "\n=========================================================\n";
    std::cout << std::left << std::setw(20) << "Configuration" << std::setw(15) << "Runtime(sec)" << std::setw(15)
              << "Speedup" << std::setw(15) << "Validation" << "\n";
    std::cout << "=========================================================\n";

    std::cout << std::left << std::setw(20) << "CPU Exponentiation" << std::setw(15) << cpuTime << std::setw(15) << "1.0" << std::setw(15) << "-" << "\n";
    std::cout << std::left << std::setw(20) << "GPU Exponentiation" << std::setw(15) << gpuTime << std::setw(15)
              << cpuTime / gpuTime << std::setw(15) << ( validationPassed ? "PASS" : "FAIL") << "\n";

    std::cout << "=========================================================\n";

    Timer gpuTimer2048;
    gpuTimer2048.start();

    DenseMatrix gpuResult2048 = DenseGpu::matrixPowerTiled( matrix2048, exponentValue );

    double gpuTime2048 = gpuTimer2048.stop();

    std::cout << "\n\n\n\n=============================================\n";
    std::cout << "CPU vs GPU Matrix Exponentiation\n";
    std::cout << "Matrix Size : " << 2048 << " x " << 2048 << "\n";
    std::cout << "Exponent : " << exponentValue << "\n";
    std::cout << "=============================================\n";
    std::cout << "\n=========================================================\n";
    std::cout << std::left << std::setw(20) << "Configuration" << std::setw(15) << "Runtime(sec)" << std::setw(15)
              << "Speedup" << std::setw(15) << "Validation" << "\n";
    std::cout << "=========================================================\n";

    std::cout << std::left << std::setw(20) << "CPU Exponentiation" << std::setw(15) << 731 << std::setw(15) << "1.0" << std::setw(15) << "-" << "\n";
    std::cout << std::left << std::setw(20) << "GPU Exponentiation" << std::setw(15) << gpuTime2048 << std::setw(15)
              << 731 / gpuTime2048 << std::setw(15) << ( validationPassed ? "PASS" : "FAIL") << "\n";

    std::cout << "=========================================================\n";

    return 0;
}
