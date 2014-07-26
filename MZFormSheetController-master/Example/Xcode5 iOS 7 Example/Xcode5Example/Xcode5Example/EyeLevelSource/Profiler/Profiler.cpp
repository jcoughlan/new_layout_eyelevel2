//Author: Ryan Sullivan
//Notes: Based off of the example in games programming gems volume 1.
//TODO:	
//		[X]Average needs to be calculated better, use of some invalid number maybe.


#include "Profiler.h"

#include <assert.h>
#include <iostream>
#include <fstream>

#define INVALID_PROFILE_TIME 0.0f

Profiler::traceSample Profiler::mSamples[MAX_PROFILE_SAMPLES];


void Profiler::initialise()
{
#if PROFILING_ENABLED
	//set our profiling array to all invalid.
	for( unsigned int i = 0; i < MAX_PROFILE_SAMPLES; ++i )
	{
		mSamples[i].bValid = false;
	}

#endif
}



void Profiler::beginTrace( char* traceName ) 
{

#if PROFILING_ENABLED
	//find our trace if it allready exists, otheriwse add it
	for( unsigned int i = 0; i < MAX_PROFILE_SAMPLES; ++i )
	{
		if( mSamples[i].bValid )
		{
			//this ones valid does it match
			if( strcmp( mSamples[i].cName, traceName ) == 0 )
			{
				//this is our's
				mSamples[i].highPrecisionTimer.start();
				++mSamples[i].uiCallCount;
				break;
			}
		}
		else
		{
			//it doesnt exist yet.
			mSamples[i].bValid = true;
			strcpy( mSamples[i].cName, traceName );
			mSamples[i].highPrecisionTimer = Timer();
			mSamples[i].highPrecisionTimer.start();
			mSamples[i].dTotalTraceTime = 0;
			mSamples[i].fAverageTraceTime = INVALID_PROFILE_TIME;
			mSamples[i].uiCallCount = 1;
			mSamples[i].dMaxTime = 0;

			mSamples[i].dMinTime = 999999999;
            mSamples[i].dMinTime *=100;
			break;
		}
	}
#endif

}

void Profiler::outputToBuffer( void )
{
#if PROFILING_ENABLED

	std::cout << "|	Av	|	Min	|	Max	|	#	|	Profile Name	|" << std::endl;
	std::cout << "---------------------------------------------------" << std::endl;

	for( unsigned int i = 0; i < MAX_PROFILE_SAMPLES; ++i )
	{
		if( mSamples[i].bValid )
		{
			
			std::cout << writeDataToString(i);
		}
		else
		{
			break;
		}
	}

#endif
}

void Profiler::outputToCSV( const std::string& filename )
{
#if PROFILING_ENABLED
	std::ofstream file( filename.c_str() );

	file << "Average,Minimum,Maximum,NumberOfCalls,SegmentName" << std::endl;

	for( unsigned int i = 0; i < MAX_PROFILE_SAMPLES; ++i )
	{
		if( mSamples[i].bValid )
		{
			file << writeDataToCSVString(i) << std::endl;
		}
		else
		{
			break;
		}
	}

#endif
}

void Profiler::outputToFile( const std::string& filename )
{
#if PROFILING_ENABLED
	std::ofstream file( filename.c_str() );

	file << "|	Av	|	Min	|	Max	|	#	|	Profile Name	|" << std::endl;
	file << "--------------------------------------------------------------------------------" << std::endl;

	for( unsigned int i = 0; i < MAX_PROFILE_SAMPLES; ++i )
	{
		if( mSamples[i].bValid )
		{
			file << writeDataToString(i) << std::endl;
		}
		else
		{
			break;
		}
	}
#endif
}

const std::string Profiler::writeDataToCSVString( int index )
{
#if PROFILING_ENABLED
	char ave[16], min[16], max [16], num[16], name[256], line[256] ;

	sprintf( ave, "%lld", mSamples[index].fAverageTraceTime );
	sprintf( min, "%lld", mSamples[index].dMinTime );
	sprintf( max, "%lld", mSamples[index].dMaxTime );

	sprintf( num, "%d", mSamples[index].uiCallCount );

	strcpy( name, mSamples[index].cName );

	sprintf( line, "%5s,%s,	%s,	%3s,%s", ave, min, max, num, name );

	return std::string(line);
#endif
}

const std::string Profiler::writeDataToString( int index )
{
#if PROFILING_ENABLED
	char ave[16], min[16], max [16], num[16], name[256], line[256] ;

	sprintf( ave, "%lld", mSamples[index].fAverageTraceTime );
	sprintf( min, "%lld", mSamples[index].dMinTime );
	sprintf( max, "%lld", mSamples[index].dMaxTime );

	sprintf( num, "%3d", mSamples[index].uiCallCount );

	strcpy( name, mSamples[index].cName );

	sprintf( line, "|	%5s	|	%s	|	%s	|	%3s	|	%s	|\n", ave, min, max, num, name );

	return std::string(line);
#endif
}

const std::string Profiler::writeBriefDataToString( int index )
{
#if PROFILING_ENABLED
	char ave[16], name[256], line[256];

	sprintf( ave, "%lld", mSamples[index].fAverageTraceTime );
	strcpy( name, mSamples[index].cName );

	sprintf( line, "%s %3s\n",name, ave  );

	return std::string(line);
#endif
}


void Profiler::endTrace( char* traceName )
{
#if PROFILING_ENABLED
	//find our trace if it allready exists, otheriwse add it
	for( unsigned int i = 0; i < MAX_PROFILE_SAMPLES; ++i )
	{
		if( mSamples[i].bValid )
		{
			//this ones valid does it match
			if( strcmp( mSamples[i].cName, traceName ) == 0 )
			{
				//this is our's
				mSamples[i].highPrecisionTimer.stop();
				double timeThisFrame = mSamples[i].highPrecisionTimer.getElapsedTime();

				//update min if neccessary
				if( mSamples[i].dMinTime > timeThisFrame )
				{
					mSamples[i].dMinTime = timeThisFrame;
				}

				//update max if neccessary
				if( mSamples[i].dMaxTime < timeThisFrame )
				{
					mSamples[i].dMaxTime = timeThisFrame;
				}

				mSamples[i].dTotalTraceTime += timeThisFrame;

				//update average
				mSamples[i].fAverageTraceTime = mSamples[i].dTotalTraceTime / (float)mSamples[i].uiCallCount;

				break;
			}
		}
		else
		{
			assert(!"END TRACE CALLED WITH NO BEGIN");
		}
	}
#endif
}
