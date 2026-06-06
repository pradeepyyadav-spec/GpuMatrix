#pragma once
#include <cuda_runtime.h>

class CudaTimer
{
public:
    CudaTimer()
    {
        cudaEventCreate( &startEvent_ );
        cudaEventCreate( &stopEvent_ );
    }

    ~CudaTimer()
    {
        cudaEventDestroy( startEvent_ );
        cudaEventDestroy( stopEvent_ );
    }

    void start()
    {
        cudaEventRecord( startEvent_ );
    }

    float stop()
    {
        cudaEventRecord( stopEvent_ );
        cudaEventSynchronize( stopEvent_ );
        float elapsedMilliseconds = 0.0f;
        cudaEventElapsedTime( &elapsedMilliseconds, startEvent_, stopEvent_ );
        return static_cast<double>( elapsedMilliseconds );
    }

private:
    cudaEvent_t startEvent_;
    cudaEvent_t stopEvent_;
};
