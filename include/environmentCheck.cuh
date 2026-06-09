#include <cuda_runtime.h>
#include <iostream>

void printDeviceInfo()
{
    int deviceCount;
    cudaGetDeviceCount(&deviceCount);

    std::cout << "GPU MATRIX COMPUTATION FRAMEWORK" << std::endl;
    std::cout << "Scientific + EDA Workloads" << std::endl;
    std::cout << "Benchmark Suite Initialized" << std::endl;
    std::cout << "=================================" << std::endl;

    std::cout << "CUDA Devices on Machine : " << deviceCount << std::endl;

    if( deviceCount == 0 )
    {
        std::cout << "No CUDA device available. Exiting..." << std::endl;
        exit(0);
    }
 
    for( int i=0; i < deviceCount; i++ )
    {
        cudaDeviceProp prop;
        cudaGetDeviceProperties( &prop, i );

        std::cout << << std::endl << "GPU : " << prop.name << std::endl;
        std::cout << "Global Memory (GB): " << prop.totalGlobalMem /( 1024.0 * 1024 * 1024 ) << std::endl;
        std::cout << "SM Count : " << prop.multiProcessorCount << std::endl;
        std::cout << "Compute Capability : " << prop.major << "." << prop.minor << std::endl;
        std::cout << "=================================" << std::endl;

        std::cout << "Tile Size : " << TILE_SIZE << std::endl;
        #ifdef ENABLE_UNROLL
            std::cout << "Loop Unrolling : ON" << std::endl;
        #else
            std::cout << "Loop Unrolling : OFF" << std::endl;
        #endif
        std::cout << "=================================" << std::endl << std::endl << std::endl;
    }

    return 0;
}
