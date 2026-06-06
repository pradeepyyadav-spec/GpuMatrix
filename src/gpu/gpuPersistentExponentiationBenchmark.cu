#include "../../include/denseGpu.hpp"
#include "../../include/matrixGenerator.hpp"
#include "../../include/timer.hpp"

#include <iostream>
#include <iomanip>
#include <cmath>

bool validateResults( const DenseMatrix& matrixA, const DenseMatrix& matrixB )
{
    constexpr float tolerance = 1e-3f;

    const float* dataA = matrixA.getRawData();
    const float* dataB = matrixB.getRawData();

    for ( size_t index = 0; index < matrixA.getElementCount(); index++ )
    {
        if ( std::isnan( dataA[index] ) || std::isnan( dataB[index] ) )
        {
            return false;
        }

        if ( std::fabs( dataA[index] - dataB[index]) > tolerance )
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
    std::cout << "GPU Persistent Exponentiation Benchmark\n";
    std::cout << "Matrix Size : " << matrixSize << " x " << matrixSize << "\n";
    std::cout << "Exponent : " << exponentValue << "\n";
    std::cout << "=============================================\n";

    Timer tiledTimer;
    DenseGpu::resetAccumulatedKernelRuntime();
    tiledTimer.start();

    DenseMatrix tiledResult = DenseGpu::matrixPowerTiled( matrix, exponentValue );
    double tiledRuntime = tiledTimer.stop();
    double tiledKernelRuntime = DenseGpu::getAccumulatedKernelRuntimeMs();

    Timer persistentTimer;
    DenseGpu::resetAccumulatedKernelRuntime();
    persistentTimer.start();
    
    DenseMatrix persistentResult = DenseGpu::matrixPowerPersistent( matrix, exponentValue );
    double persistentRuntime = persistentTimer.stop();
    double persistentKernelRuntime = DenseGpu::getAccumulatedKernelRuntimeMs();
    bool validationPassed = validateResults( tiledResult, persistentResult);

    std::cout << "\n===============================================================\n";
    std::cout << std::left << std::setw(25) << "Configuration" << std::setw(15) << "Runtime(sec)" << std::setw(15) << "Kernel(ms)" << std::setw(15) << "Validation" << "\n";
    std::cout << "===============================================================\n";
    std::cout << std::left << std::setw(25) << "GPU Exponentiation" << std::setw(15) << tiledRuntime << std::setw(15) << tiledKernelRuntime << std::setw(15) << "-" << "\n";
    std::cout << std::left << std::setw(25) << "GPU Persistent" << std::setw(15) << persistentRuntime
              << std::setw(15) << persistentKernelRuntime << std::setw(15) << ( validationPassed ? "PASS" : "FAIL") << "\n";
    std::cout << "===============================================================\n";
    std::cout << "Persistent Speedup : " << tiledRuntime / persistentRuntime << "x\n";
    std::cout << "===============================================================\n";

    return 0;
}
