//
//  Audio.h
//  sampler
//
//  Created by Julien Bloit on 14/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef sampler_Audio_h
#define sampler_Audio_h

#include "mo_audio.h"
#undef TWO_PI
#include "FileWvIn.h"
#include "FileWvOut.h"
#include "Sample.h"
#include "CircularBuffer.h"


class Audio{
public:
    Audio();
    ~Audio();
    void callback( Float32 * buffer, UInt32 numFrames, void * userData );
    void play();
    void record();

    Sample * samples;
    
private :
    bool m_doPlay;
    bool m_isRecording;
    
    CircularBuffer<float> * tmpRecBuffer;
//    stk::FileWvIn m_fileIn;
//    stk::FileWvOut m_fileOut;
    
    int nbSamples;
    

};



#endif
