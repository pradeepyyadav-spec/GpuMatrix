#include <cuda_runtime.h>
#include <iostream>

int main()
{
    int deviceCount;

    cudaGetDeviceCount(&deviceCount);

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

        std::cout << "GPU : " << prop.name << std::endl;
        std::cout << "Global Memory (GB): " << prop.totalGlobalMem /( 1024.0 * 1024 * 1024 ) << std::endl;
        std::cout << "SM Count : " << prop.multiProcessorCount << std::endl;
        std::cout << "Compute Capability : " << prop.major << "." << prop.minor << std::endl;
    }

    return 0;
}
