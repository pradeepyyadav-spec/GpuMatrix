#pragma once

#include <chrono>

class Timer
{
public:

    void start()
    {
        startTime_ =
            std::chrono::high_resolution_clock::now();
    }

    double stop()
    {
        auto endTime =
            std::chrono::high_resolution_clock::now();

        return std::chrono::duration<double>(
            endTime - startTime_
        ).count();
    }

private:

    std::chrono::high_resolution_clock::time_point startTime_;
};
