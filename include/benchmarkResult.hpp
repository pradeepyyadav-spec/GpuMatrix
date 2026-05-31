#pragma once

struct BenchmarkResult
{
    std::string configurationName;
    int matrixSize = 0;
    double executionTimeSeconds = 0.0;
    double speedup = 0.0;
    double gflops = 0.0;
    double memoryUsageMb = 0.0;
};
