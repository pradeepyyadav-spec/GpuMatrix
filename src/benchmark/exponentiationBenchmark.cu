#include "../../include/denseCpu.hpp"
#include "../../include/denseGpu.hpp"
#include "../../include/matrixGenerator.hpp"
#include "../../include/timer.hpp"
#include "../../include/environmentCheck.cuh"
#include <iostream>
#include <iomanip>
#include <cmath>

bool validateResults( const DenseMatrix& referenceMatrix, const DenseMatrix& testMatrix) {
    constexpr float tolerance = 1e-2f;

    const float* referenceData = referenceMatrix.getRawData();
    const float* testData = testMatrix.getRawData();

    for ( size_t index = 0; index < referenceMatrix.getElementCount(); index++ )
    {
        if ( std::isnan( referenceData[index] ) || std::isnan( testData[index] ) )
        {
            return false;
        }

        if ( std::fabs( referenceData[index] - testData[index] ) > tolerance )
        {
            return false;
        }
    }
    return true;
}

void printResultRow( const std::string& configurationName, double runtimeSeconds, const std::string& kernelTime, double speedup, const std::string& validation )
{
    std::cout << std::left << std::setw(30) << configurationName << std::setw(15) << runtimeSeconds
              << std::setw(15) << kernelTime << std::setw(15) << speedup << std::setw(15) << validation << "\n";
}

int main()
{
    printDeviceInfo();

#ifdef LARGE_MAT
    constexpr int matrixSizes[] = { 1024, 2048 };
#else
    constexpr int matrixSizes[] = { 1024 };
#endif

    constexpr int exponentValue = 100;

    for ( int matrixSize : matrixSizes )
    {
        DenseMatrix matrix = MatrixGenerator::createEdaDenseMatrix( matrixSize );

        std::cout << "\n\n=========================================================\n";
        std::cout << "Matrix Exponentiation Benchmark\n";
        std::cout << "Matrix Size : " << matrixSize << " x " << matrixSize << "\n";
        std::cout << "Exponent : " << exponentValue << "\n";
        std::cout << "=========================================================\n";

        /* CPU */

        Timer cpuTimer;
        cpuTimer.start();
        DenseMatrix cpuResult = DenseCpu::matrixPower( matrix, exponentValue );
        double cpuRuntime = cpuTimer.stop();

        /* GPU Naive */

        DenseGpu::resetAccumulatedKernelRuntime();
        Timer gpuNaiveTimer;
        gpuNaiveTimer.start();
        DenseMatrix gpuNaiveResult = DenseGpu::matrixPowerNaive( matrix, exponentValue );
        double gpuNaiveRuntime = gpuNaiveTimer.stop();
        double gpuNaiveKernelRuntime = DenseGpu::getAccumulatedKernelRuntimeMs();
        bool gpuNaiveValidation = validateResults( cpuResult, gpuNaiveResult );

        /* GPU Tiled */

        DenseGpu::resetAccumulatedKernelRuntime();
        Timer gpuTiledTimer;
        gpuTiledTimer.start();
        DenseMatrix gpuTiledResult = DenseGpu::matrixPowerTiled( matrix, exponentValue );
        double gpuTiledRuntime = gpuTiledTimer.stop();
        double gpuTiledKernelRuntime = DenseGpu::getAccumulatedKernelRuntimeMs();
        bool gpuTiledValidation = validateResults( cpuResult, gpuTiledResult );

        /* GPU Persistent */

        DenseGpu::resetAccumulatedKernelRuntime();
        Timer gpuPersistentTimer;
        gpuPersistentTimer.start();
        DenseMatrix gpuPersistentResult = DenseGpu::matrixPowerPersistent( matrix, exponentValue );
        double gpuPersistentRuntime = gpuPersistentTimer.stop();
        double gpuPersistentKernelRuntime = DenseGpu::getAccumulatedKernelRuntimeMs();
        bool gpuPersistentValidation = validateResults( cpuResult, gpuPersistentResult );

        /* Output */

        std::cout << "\n====================================================================================================\n";
        std::cout << std::left << std::setw(30) << "Configuration" << std::setw(15) << "Runtime(sec)" << std::setw(15)
                  << "Kernel(ms)" << std::setw(15) << "Speedup" << std::setw(15) << "Validation" << "\n";
        std::cout << "====================================================================================================\n";

        printResultRow( "CPU Exponentiation", cpuRuntime, "-", 1.0, "-" );
        printResultRow( "GPU Naive Exponentiation", gpuNaiveRuntime, std::to_string( gpuNaiveKernelRuntime), cpuRuntime / gpuNaiveRuntime, gpuNaiveValidation ? "PASS" : "FAIL" );
        printResultRow( "GPU Tiled Exponentiation", gpuTiledRuntime, std::to_string( gpuTiledKernelRuntime), cpuRuntime / gpuTiledRuntime, gpuTiledValidation ? "PASS" : "FAIL" );
        printResultRow( "GPU Persistent Exponentiation", gpuPersistentRuntime, std::to_string( gpuPersistentKernelRuntime), cpuRuntime / gpuPersistentRuntime, gpuPersistentValidation ? "PASS" : "FAIL" );

        std::cout << "====================================================================================================\n";
        std::cout << "Tiled Improvement on Naive : " << gpuNaiveRuntime / gpuTiledRuntime << "x\n";
        std::cout << "Persistent Improvement on Tiled : " << gpuTiledRuntime / gpuPersistentRuntime << "x\n";
        std::cout << "====================================================================================================\n";
    }

    return 0;

}

