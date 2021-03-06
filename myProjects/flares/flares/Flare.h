//
//  Flare.h
//  flares
//
//  Created by Julien Bloit on 15/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef flares_Flare_h
#define flares_Flare_h


#import "GLViewController.h"
#import "Geometry.h"
#import "Texture.h"
#include <map>


class Flare{
public:
    
    GLvertex2f G;
    GLvertex2f vel;
    GLvertex2f position;
    float friction;
    int radius;
    GLcolor4f c;
    
    float scale;
    GLuint tex;

    float frameRateFactor; 
    
    
    Flare();
    ~Flare();
    void update(float dt);
    void render();

};



class FlareSound{


};

#endif
