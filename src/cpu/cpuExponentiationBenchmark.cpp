#include "../../include/timer.hpp"
#include "../../include/denseCpu.hpp"
#include "../../include/matrixGenerator.hpp"
#include "../../include/benchmarkResult.hpp"

#include <iostream>
#include <vector>
#include <iomanip>

int getExponentiationMultiplyCount( int exponentValue )
{
    int multiplicationCount = 0;

    while (exponentValue > 0)
    {
        multiplicationCount++;

        if (exponentValue & 1)
        {
            multiplicationCount++;
        }

        exponentValue >>= 1;
    }

    return multiplicationCount;
}

int main()
{
    constexpr int matrixSizes[] = { 512, 1024 };

    constexpr int exponentValue = 100;

    std::cout << " Exp : 32 " << getExponentiationMultiplyCount(32) << " Exp : 64 " << getExponentiationMultiplyCount(64) << " Exp : 100 " << getExponentiationMultiplyCount(100) << " Exp : 256 " << getExponentiationMultiplyCount(256) << std::endl;

    std::vector<BenchmarkResult> benchmarkResults;

    std::cout << "=============================================\n"
        << "CPU Matrix Exponentiation Benchmark\n" << "Exponent = " << exponentValue << "\n"
        << "=============================================\n";

    for (int matrixSize : matrixSizes)
    {
        std::cout << "\n---------------------------------------------\n"
            << "Matrix Size : " << matrixSize << " x " << matrixSize
            << "\n---------------------------------------------\n";

        DenseMatrix matrix = MatrixGenerator::createEdaDenseMatrix( matrixSize );

        double matrixMemoryMb = static_cast<double>( matrix.getSizeInBytes() ) / (1024.0 * 1024.0);

        std::cout << "Approx Matrix Memory : " << std::fixed << std::setprecision(2) << matrixMemoryMb << " MB" << std::endl;

        Timer timer;

        timer.start();

        DenseMatrix result = DenseCpu::matrixPower( matrix, exponentValue );

        double executionTime = timer.stop();

        BenchmarkResult benchmarkResult;

        benchmarkResult.matrixSize = matrixSize;

        benchmarkResult.executionTimeSeconds = executionTime;

        double floatingPointOperations = getExponentiationMultiplyCount( exponentValue ) * 2.0 * matrixSize * matrixSize * matrixSize;

        benchmarkResult.gflops = floatingPointOperations / (executionTime * 1e9);

        benchmarkResults.push_back( benchmarkResult );

        std::cout << "Execution Time : " << executionTime << " sec" << std::endl;

        std::cout << "GFLOPS : " << benchmarkResult.gflops << std::endl;
    }

    std::cout << "\n\n=========================================================\n"
        << "Benchmark Summary\n"
        << "=========================================================\n";

    std::cout << std::left << std::setw(15) << "Size" << std::setw(20) << "Runtime(sec)" << std::setw(20) << "GFLOPS" << std::endl;

    std::cout << "---------------------------------------------------------\n";

    for ( const auto& result : benchmarkResults )
    {
        std::cout << std::left << std::setw(15) << result.matrixSize << std::setw(20) << std::fixed << std::setprecision(4) << result.executionTimeSeconds << std::setw(20) << result.gflops << std::endl;
    }

    std::cout << "=========================================================\n";

    return 0;
}
