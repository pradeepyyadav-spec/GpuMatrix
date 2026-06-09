#include "../../include/denseCpu.hpp"
#include "../../include/denseGpu.hpp"
#include "../../include/matrixGenerator.hpp"
#include "../../include/timer.hpp"
#include "../../include/environmentCheck.cuh"

#include <iostream>
#include <iomanip>

bool validateResults( const DenseMatrix& cpuResult, const DenseMatrix& gpuResult )
{
    constexpr float tolerance = 1e-3f;
    const float* cpuData = cpuResult.getRawData();

    const float* gpuData = gpuResult.getRawData();

    for ( size_t index = 0; index < cpuResult.getElementCount(); index++ )
    {
        float difference = std::abs( cpuData[index] - gpuData[index] );

        if (difference > tolerance)
        {
            std::cout << "Validation failed at index " << index << std::endl;
            return false;
        }
    }

    return true;
}

int main()
{
    printDeviceInfo();
    constexpr int matrixSize = 1024;

    DenseMatrix matrixA = MatrixGenerator::createRandomDenseMatrix( matrixSize );
    DenseMatrix matrixB = MatrixGenerator::createRandomDenseMatrix( matrixSize );

    std::cout << "=============================================\n";
    std::cout << "CPU vs GPU Matrix Multiplication\n";
    std::cout << "Matrix Size : " << matrixSize << " x " << matrixSize << "\n";
    std::cout << "=============================================\n";

    Timer cpuTimer;
    cpuTimer.start();

    DenseMatrix cpuResult = DenseCpu::matrixMultiply( matrixA, matrixB );

    double cpuTime = cpuTimer.stop();

    Timer naiveTimer;
    naiveTimer.start();

    DenseMatrix gpuNaiveResult = DenseGpu::matrixMultiplyNaive( matrixA, matrixB );

    double naiveTime = naiveTimer.stop();

    Timer tiledTimer;
    tiledTimer.start();

    DenseMatrix gpuTiledResult = DenseGpu::matrixMultiplyTiled( matrixA, matrixB );

    double tiledTime = tiledTimer.stop();

    bool naiveValid = validateResults( cpuResult, gpuNaiveResult );
    bool tiledValid = validateResults( cpuResult, gpuTiledResult );

    std::cout << "\n=========================================================\n";
    std::cout << std::left << std::setw(20) << "Configuration" << std::setw(15) << "Runtime(sec)" << std::setw(15) << "Speedup" << std::setw(15) << "Validation" << "\n";
    std::cout << "=========================================================\n";

    std::cout << std::left << std::setw(20) << "CPU Serial" << std::setw(15) << cpuTime << std::setw(15) << "1.0" << std::setw(15) << "-" << "\n";
    std::cout << std::left << std::setw(20) << "GPU Naive" << std::setw(15) << naiveTime << std::setw(15) << cpuTime / naiveTime
              << std::setw(15) << (naiveValid ? "PASS" : "FAIL") << "\n";
    std::cout << std::left << std::setw(20) << "GPU Tiled" << std::setw(15) << tiledTime << std::setw(15) << cpuTime / tiledTime
              << std::setw(15) << (tiledValid ? "PASS" : "FAIL") << "\n";

    std::cout << "=========================================================\n";

    return 0;
}
