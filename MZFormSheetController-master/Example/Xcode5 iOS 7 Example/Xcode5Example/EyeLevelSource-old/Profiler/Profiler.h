#ifndef PROFILER_H
#define PROFILER_H

#include "HighResolutionTimer.h"
#include <string>

//switch profiling on and off
#define PROFILING_ENABLED 1

//the maximum number of traces that can be carried out.
#define MAX_PROFILE_SAMPLES 50

class IRenderSystem;

class Profiler
{

private:
	struct traceSample
	{
		bool			bValid;
		char			cName[256];				//the name of the trace
		Timer			highPrecisionTimer;
		uint64_t		dTotalTraceTime;
		uint64_t		fAverageTraceTime;		//the average time it took this trace to execute.
		uint64_t		dMaxTime;				//the max time it took this trace to execute
		uint64_t		dMinTime;				//the min time it took this trace to execute
		unsigned int	uiCallCount;			//the number of times this trace has been executed.
	};

public:
	static void initialise();

	static void beginTrace( char* traceName ); 
	static void endTrace( char* endTrace );

	static void outputToBuffer();
	static void outputToFile( const std::string& filename );
	static void outputToCSV( const std::string& filename );
	
private:
	static const std::string writeDataToString( int index );
	static const std::string writeDataToCSVString( int index );
	static const std::string writeBriefDataToString( int index );	//for little displays.

	static traceSample mSamples[MAX_PROFILE_SAMPLES];



};


#endif
