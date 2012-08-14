//
//  Audio.h
//  fmLab
//
//  Created by Julien Bloit on 13/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef fmLab_Audio_h
#define fmLab_Audio_h

#include "mo_audio.h"

class Audio
{
public:
    Audio();
    ~Audio();
    
    void callback( Float32 * buffer, UInt32 numFrames, void * userData );
    
    void setFreq(float freq) { m_freq = freq; }
    
private:
    
    float m_modGain;
    float m_modFreq;
    float m_modPhase;
    
    float m_gain;
    float m_freq;
    float m_phase;
};



#endif
