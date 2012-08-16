//
//  Sample.h
//  sampler
//
//  Created by Julien Bloit on 14/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef sampler_Sample_h
#define sampler_Sample_h

#include "FileWvIn.h"
#include "FileWvOut.h"

class Sample {
    
public:
    Sample();
    Sample(int index);
    ~Sample();
    
    int index;
    char fileName[50];
    
    void armPlay();
    void recordStart();
    void recordStop();
    void noteOn();
    
    bool doPlay;
    bool doRecord;
    
    stk::FileWvIn fileReader;
    stk::FileWvOut fileWriter;

private:
    
    

};

#endif
