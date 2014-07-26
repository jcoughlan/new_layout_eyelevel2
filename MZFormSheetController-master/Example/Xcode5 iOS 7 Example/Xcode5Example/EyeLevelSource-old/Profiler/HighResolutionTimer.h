#ifndef HIGHRESOLUTIONTIMER_H
#define HIGHRESOLUTIONTIMER_H

/**
* High resolution timer for MAC OS's including iOS.
*
* Returns time in ns, used by the Profiler class.
**/

#include <mach/mach_time.h>

class Timer
{
public:
	Timer()
	{
        mach_timebase_info(&m_TimerInfo);
	}

	void start()
	{
        m_Stopped = false;
        m_Start = mach_absolute_time();
	}

	void stop()
	{
        m_Stopped = true;
        m_Stop = mach_absolute_time();
	}

	uint64_t getElapsedTime() 
	{ 
        if(!m_Stopped)
            stop();
        
        uint64_t duration = m_Stop - m_Start;
        
        /* Convert to nanoseconds */
        duration *= m_TimerInfo.numer;
        duration /= m_TimerInfo.denom;
        
        return duration;
	}

private:
    mach_timebase_info_data_t   m_TimerInfo;    //this probably doesnt change between objects - therefore should be made static.
    
    uint64_t                    m_Start;
    uint64_t                    m_Stop;
    
    
    bool                        m_Stopped;
};

#endif //HIGHRESOLUTIONTIMER_H