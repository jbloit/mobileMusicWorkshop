//
//  Sample.cpp
//  sampler
//
//  Created by Julien Bloit on 14/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include <iostream>
#include "Sample.h"
#include "Filepaths.h"

Sample::Sample(){
    //fileName[50];
     
}

//Sample::Sample(int _index){
//    index = _index;
//    sprintf(fileName, "tmpfile_%i.wav", index);
//}

Sample::~Sample(){}


void Sample::recordStop(){
    doRecord = false;
    fileWriter.closeFile();
}

void Sample::armPlay(){
    recordStop();
    doPlay = true;
}

void Sample::recordStart(){
    doPlay = false;
    doRecord = true;
    fileWriter.openFile(stlDocumentsFilepath(fileName), 1, stk::FileWrite::FILE_WAV, stk::Stk::STK_FLOAT32);
}

void Sample::noteOn(){
    doPlay = false;
    fileReader.openFile(stlDocumentsFilepath(fileName));
    fileReader.setRate(2.0);

}