//
//  Audio.cpp
//  sampler
//
//  Created by Julien Bloit on 14/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#include "Audio.h"
#include "Filepaths.h"

const float SRATE = 44100;
const float BUFFER_SIZE = 256;

void g_callback( Float32 * buffer, UInt32 numFrames, void * userData )
{
    Audio * audio = (Audio *) userData;
    
    @autoreleasepool {
        audio->callback(buffer, numFrames, userData);
    }
}


Audio::Audio()
{
    MoAudio::init(SRATE, BUFFER_SIZE, 2);
    MoAudio::start(g_callback, this);
 
    nbSamples = 2;

    samples = new Sample[nbSamples];
    for (int i = 0; i < nbSamples; i++){
        samples[i].index = i;
        sprintf(samples[i].fileName, "tmpfile_%i.wav", i);
    }
    
    tmpRecBuffer = new CircularBuffer<float>(BUFFER_SIZE*10);
    
}

Audio::~Audio(){
    delete samples;
}

// the buffer is constantly filled with audio from the mic, if you don't write over it, it'll just contain the mic sound. 
void Audio::callback( Float32 * buffer, UInt32 numFrames, void * userData )
{

    // trigger sound sample 
    for (int i=0; i<nbSamples; i++){  
        if (samples[i].doPlay)
            samples[i].noteOn();
    }
 
    // is any sample in recording mode?
    bool isRecording = false;
    int recordingSampleId;
    for (int k = 0; k < nbSamples; k++){
        isRecording = isRecording || samples[k].doRecord;  
        if (samples[k].doRecord) recordingSampleId = k;
    }
    
    
    // store dac input to buffer and play samples. 
    for(int i = 0; i < numFrames; i++){
        float inputSample = buffer[i*2];
        float sample = 0;

        for (int k = 0; k < nbSamples; k++){
            if(samples[k].fileReader.isOpen() && !samples[k].fileReader.isFinished())
                sample += samples[k].fileReader.tick();
            
            if(samples[k].fileReader.isFinished())
                samples[k].fileReader.closeFile();     
        }

        if(isRecording)
            tmpRecBuffer->put(inputSample);
        
        buffer[i*2] = sample;
        buffer[i*2+1] = sample;
    }

    if (isRecording){
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                // tell UI thread to write out file
                if(isRecording)
                {
                    float outSample;
                    while(tmpRecBuffer->get(outSample))
                    {
                        samples[recordingSampleId].fileWriter.tick(outSample);
                    }
                }
            });
        }
    
    }
    
    
    
}
