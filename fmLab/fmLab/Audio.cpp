//
//  Audio.cpp
//  fmLab
//
//  Created by Julien Bloit on 13/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include <iostream>


#include "Audio.h"


const float SRATE = 44100;
const float BUFFER_SIZE = 256;


float sineOsc(float phase)
{
    return sinf(2*M_PI*phase);
}

float triangleOsc(float phase){
    if (phase <= 0.5){
        return (-2 * phase + 1); 
    } 
    else{
        return (2 * phase - 3);
    }
}

float sawToothOsc(float phase){
    return (2*phase - 1 );
}

float squareOsc(float phase){
    if (phase <= 0.5){
        return (-1.0);
    }
    else{
        return (1.0);
    }
}


void g_callback( Float32 * buffer, UInt32 numFrames, void * userData )
{
    Audio * audio = (Audio *) userData;
    
    audio->callback(buffer, numFrames, userData);
}


Audio::Audio()
{
    MoAudio::init(SRATE, BUFFER_SIZE, 2);
    MoAudio::start(g_callback, this);
    
    currentOsc = 0;
    
    m_phase = 0;
    m_freq = 440;
    m_gain = 1;
    
    m_modPhase = 0;
    m_modFreq = m_freq * 0.25;
    m_modGain = 1000;
}

Audio::~Audio()
{
    
}

void Audio::callback( Float32 * buffer, UInt32 numFrames, void * userData )
{
    for(int i = 0; i < numFrames; i++)
    {
        float mod = m_modGain * sineOsc(m_modPhase);
        
        m_modPhase += m_modFreq/SRATE;
        if(m_modPhase > 1) m_modPhase -= 1;
        
        float sample;
        switch(currentOsc){
            case 0:
                sample = m_gain * sineOsc(m_phase);
                break;
            case 1:
                sample = m_gain * triangleOsc(m_phase);
                break;                
            case 2:
                sample = m_gain * sawToothOsc(m_phase);
                break;                
            case 3:
                sample = m_gain * squareOsc(m_phase);
                break;                
            default:
                sample = m_gain * sineOsc(m_phase);
                break;
        }
        
        m_phase += (m_freq+mod)/SRATE;
        if(m_phase > 1) m_phase -= 1;
        
        buffer[i*2] = sample;
        buffer[i*2+1] = sample;
    }
}



























