#include "../../include/timer.hpp"
#include "../../include/denseCpu.hpp"
#include "../../include/matrixGenerator.hpp"
#include "../../include/benchmarkResult.hpp"

#include <iostream>
#include <vector>
#include <iomanip>

int main()
{
    constexpr int matrixSizes[] = { 512, 1024, 2048,4096 };

    constexpr int exponentValue = 100;

    std::vector<BenchmarkResult> benchmarkResults;

    std::cout << "CPU Matrix Exponentiation Benchmark\n" << "Exponent = " << exponentValue << std::endl;

    for (int matrixSize : matrixSizes)
    {
        std::cout << "Matrix Size : " << matrixSize << " x " << matrixSize << std::endl;

        DenseMatrix matrix = MatrixGenerator::createEdaDenseMatrix( matrixSize );

        double matrixMemoryMb = static_cast<double>( matrix.getSizeInBytes() ) / (1024.0 * 1024.0);

        std::cout << "Approx Matrix Memory : " << std::fixed << std::setprecision(2) << matrixMemoryMb << " MB" << std::endl;

        Timer timer;

        timer.start();

        DenseMatrix result = DenseCpu::matrixPower( matrix, exponentValue );

        double executionTime = timer.stop();

        BenchmarkResult benchmarkResult;

        benchmarkResult.executionTimeSeconds = executionTime;

        benchmarkResults.push_back( benchmarkResult );

        std::cout << "Execution Time : " << executionTime << " sec" << std::endl;
    }

    std::cout << "Benchmark Summary" << std::endl;

    std::cout << std::left << std::setw(15) << "Matrix Size" << std::setw(20) << "Runtime (sec)" << std::endl;

    std::cout
        << "---------------------------------------------\n";

    for ( std::size_t index = 0; index < benchmarkResults.size(); index++ )
    {
        std::cout << std::left << std::setw(15) << matrixSizes[index] << std::setw(20) << std::fixed << std::setprecision(4) << benchmarkResults[index].executionTimeSeconds << std::endl;
    }

    std::cout
        << "---------------------------------------------\n";

    return 0;
}
