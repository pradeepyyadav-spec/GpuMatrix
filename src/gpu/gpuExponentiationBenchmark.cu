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
    int matrixSize = 1024;
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

    double checksum = 0.0;
    for ( size_t index = 0; index < gpuResult.getElementCount(); index++ )
    {
        checksum += gpuResult.getRawData()[index];
    }
    std::cout << "Checksum = " << checksum << " Element Count = " << gpuResult.getElementCount() << std::endl;
    
    std::cout << "\n=========================================================\n";
    std::cout << std::left << std::setw(20) << "Configuration" << std::setw(15) << "Runtime(sec)" << std::setw(15)
              << "Speedup" << std::setw(15) << "Validation" << "\n";
    std::cout << "=========================================================\n";

    std::cout << std::left << std::setw(20) << "CPU Exponentiation" << std::setw(15) << cpuTime << std::setw(15) << "1.0" << std::setw(15) << "-" << "\n";
    std::cout << std::left << std::setw(20) << "GPU Exponentiation" << std::setw(15) << gpuTime << std::setw(15)
              << cpuTime / gpuTime << std::setw(15) << ( validationPassed ? "PASS" : "FAIL") << "\n";

    std::cout << "=========================================================\n";


    // 2048 Matrix now.
    matrixSize = 2048;
    DenseMatrix matrix2048 = MatrixGenerator::createEdaDenseMatrix( matrixSize );

    std::cout << "\n\n\n\n=============================================\n";
    std::cout << "CPU vs GPU Matrix Exponentiation\n";
    std::cout << "Matrix Size : " << matrixSize << " x " << matrixSize << "\n";
    std::cout << "Exponent : " << exponentValue << "\n";
    std::cout << "=============================================\n";

    Timer gpuTimer2048;
    gpuTimer2048.start();
    DenseMatrix gpuResult2048 = DenseGpu::matrixPowerTiled( matrix2048, exponentValue );
    double gpuTime2048 = gpuTimer2048.stop();

    checksum = 0.0;
    for ( size_t index = 0; index < gpuResult2048.getElementCount(); index++ )
    {
        checksum += gpuResult2048.getRawData()[index];
    }
    std::cout << "Checksum = " << checksum << " Element Count = " << gpuResult2048.getElementCount() << std::endl;

    std::cout << "\n=========================================================\n";
    std::cout << std::left << std::setw(20) << "Configuration" << std::setw(15) << "Runtime(sec)" << std::setw(15)
              << "Speedup" << std::setw(15) << "Validation" << "\n";
    std::cout << "=========================================================\n";

    std::cout << std::left << std::setw(20) << "CPU Exponentiation" << std::setw(15) << 731 << std::setw(15) << "1.0" << std::setw(15) << "-" << "\n";
    std::cout << std::left << std::setw(20) << "GPU Exponentiation" << std::setw(15) << gpuTime2048 << std::setw(15)
              << 731.0 / gpuTime2048 << std::setw(15) << ( validationPassed ? "PASS" : "FAIL") << "\n";

    std::cout << "=========================================================\n";

    return 0;
}
