#pragma once

#include <string>

struct GpuInfo
{
    std::string gpuName;
    double globalMemoryGb = 0.0;
    int multiprocessorCount = 0;
    int computeCapabilityMajor = 0;
    int computeCapabilityMinor = 0;
};
