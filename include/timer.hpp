#ifndef TIMER_HPP
#define TIMER_HPP

#include <chrono>
#include <iostream>

class Timer {

private:

    std::chrono::highResolutionClock::timePoint startTime;

public:

    void start()
    {
        startTime = std::chrono::highResolutionClock::now();
    }

    double stop()
    {
        auto end = std::chrono::highResolutionClock::now();

        return std::chrono::duration<double>( end - startTime).count();
    }
};

#endif
