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
    printDeviceInfo();

    constexpr int matrixSizes = 4096;
    constexpr int exponentValue = 100;

    DenseMatrix matrix = MatrixGenerator::createEdaDenseMatrix( matrixSize );

    switch ( profileMode )
    {
        case ProfileMode::Naive:
            DenseMatrix gpuNaiveResult = DenseGpu::matrixMultiplyNaive( matrix, matrix );
            break;

        case ProfileMode::Tiled:
            DenseMatrix gpuTiledResult = DenseGpu::matrixMultiplyTiled( matrix, matrix );
            break;

        case ProfileMode::Warmup:
            DenseGpu::matrixMultiplyTiled( matrix, matrix );
            break;
    }

    return 0;

}

