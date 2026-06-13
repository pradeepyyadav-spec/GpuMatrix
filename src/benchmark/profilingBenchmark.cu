#include "../../include/denseCpu.hpp"
#include "../../include/denseGpu.hpp"
#include "../../include/matrixGenerator.hpp"
#include "../../include/timer.hpp"
#include "../../include/environmentCheck.cuh"
#include <iostream>
#include <iomanip>
#include <cmath>

enum class ProfileMode
{
    Naive,
    Tiled,
    Warmup
};

int main( int argc, char* argv[] )
{
    printDeviceInfo();
    ProfileMode profileMode = ProfileMode::Naive;

    if ( argc > 1 )
    {
        std::string argument = argv[1];
        if ( argument == "naive" )
            profileMode = ProfileMode::Naive;
        else if ( argument == "tiled" )
            profileMode = ProfileMode::Tiled;
        else if ( argument == "warmup" )
            profileMode = ProfileMode::Warmup;
        else
        {
            std::cerr << "Usage: " << argv[0] << " [naive|tiled|warmup]\n";
            return 1;
        }
    }

    constexpr int matrixSizes = 4096;
    constexpr int exponentValue = 100;

    DenseMatrix matrix = MatrixGenerator::createEdaDenseMatrix( matrixSize );

    switch ( profileMode )
    {
        case ProfileMode::Naive:
            std::cout << "Profiling Naive Implementation" << std::endl;
            DenseMatrix gpuNaiveResult = DenseGpu::matrixMultiplyNaive( matrix, matrix );
            break;

        case ProfileMode::Tiled:
            std::cout << "Profiling Tiled Implementation" << std::endl;
            DenseMatrix gpuTiledResult = DenseGpu::matrixMultiplyTiled( matrix, matrix );
            break;

        case ProfileMode::Warmup:
            std::cout << "Warming up" << std::endl;
            DenseGpu::matrixMultiplyTiled( matrix, matrix );
            break;
    }

    return 0;

}

