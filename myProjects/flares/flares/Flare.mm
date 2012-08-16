//
//  Flare.cpp
//  flares
//
//  Created by Julien Bloit on 15/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include <iostream>
#include "Flare.h"

Flare::Flare(){
    
    G.x = 0.;
    G.y = 0.01;
    
    vel.x = 0;
    vel.y = 0;
    
    friction = -0.9;
    radius = 0.1;
    
    frameRateFactor = 10.0;
    
}

Flare::~Flare(){
}

void Flare::update(float dt){
    
    dt *= frameRateFactor;
    
    vel.x += G.x * dt;
    vel.y += G.y * dt;

    
    position.x += vel.x * dt;
    position.y += vel.y * dt;
    

    
    // check boundaries
    if(position.x < (-1+radius)) {
        position.x = (-1+radius);
        vel.x *= friction;
        [[NSNotificationCenter defaultCenter] postNotificationName: @"bounce" object:nil];
    } else if(position.x >= (1.0 - radius)) {
        position.x = 1.0 -radius;
        vel.x *= friction;
        [[NSNotificationCenter defaultCenter] postNotificationName: @"bounce" object:nil];
    }
    
    if(position.y < (-1+radius)) {
        position.y = -1+radius;
        vel.y *= friction;
        [[NSNotificationCenter defaultCenter] postNotificationName: @"bounce" object:nil];
    } else if(position.y >= (1. - radius)) {
        position.y = 1. - radius;
        vel.y *= friction; 
        [[NSNotificationCenter defaultCenter] postNotificationName: @"bounce" object:nil];
    }
    
    

    
    
//
//    float r = 0.1;
//    float g = 0.6;
//    float b = 0.8;
//    
//    scale = 1 ;
//    
//    c = GLcolor4f(r, g, b, 1);
}

void Flare::render(){

    GLvertex3f square[6];
    
    float r = 0.5;
    square[0] = GLvertex3f(-r, -r, 0);
    square[1] = GLvertex3f( r, -r, 0);
    square[2] = GLvertex3f(-r,  r, 0);
    
    square[3] = GLvertex3f( r, -r, 0);
    square[4] = GLvertex3f( r,  r, 0);
    square[5] = GLvertex3f(-r,  r, 0);
    
    glVertexPointer(3, GL_FLOAT, 0, square);
    glEnableClientState(GL_VERTEX_ARRAY);
    
    glTranslatef(position.x, position.y, 0);
    glScalef(scale, scale, scale);
    
    glColor4f(c.r, c.g, c.b, 1);
    
    GLvertex2f squareTexcoord[6];
    
    squareTexcoord[0] = GLvertex2f(0, 0);
    squareTexcoord[1] = GLvertex2f(1, 0);
    squareTexcoord[2] = GLvertex2f(0, 1);
    
    squareTexcoord[3] = GLvertex2f(1, 0);
    squareTexcoord[4] = GLvertex2f(1, 1);
    squareTexcoord[5] = GLvertex2f(0, 1);
    
    glTexCoordPointer(2, GL_FLOAT, 0, squareTexcoord);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, tex);
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
}