//
//  GLViewController.m
//  MobileMusic2
//
//  Created by Spencer Salazar on 7/9/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "GLViewController.h"
#import "Geometry.h"
#import <CoreMotion/CoreMotion.h>
#include "Flare.h"
#include "Audio.h"
//------------------------------------------------------------------------------
// name: uiview2gl
// desc: convert UIView coordinates to the OpenGL coordinate space
//------------------------------------------------------------------------------
GLvertex2f uiview2gl(CGPoint p, UIView * view)
{
    GLvertex2f v;
    float aspect = fabsf(view.bounds.size.width / view.bounds.size.height);
    v.x = ((p.x - view.bounds.origin.x)/view.bounds.size.width)*2-1;
    v.y = (((p.y - view.bounds.origin.y)/view.bounds.size.height)*2-1)/aspect;
    return v;
}





@interface GLViewController (){
    float time;
    
    GLuint tex;

    Flare * aFlare;
    
    CMMotionManager * motionManager;
    
    CMDeviceMotion * devMotion;
    
    float Width, Height;
    
    bool doMotionUpdate;
    
    Audio * audio;
    
    NSNotificationCenter * notifCenter;
    NSOperationQueue *mainQueue;
    
}

@property (strong, nonatomic) EAGLContext *context;

@end

@implementation GLViewController

@synthesize context;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:self.context];
    
    glEnable(GL_TEXTURE_2D);

    tex = loadTexture(@"flare.png");
    
    time = 0;
    
    aFlare = new Flare();
    aFlare->position.x = 0;
    aFlare->position.y = 0;
    //aFlare->c = GLcolor4f(1, 1, 1, 1);
    aFlare->scale = 1;
    aFlare->tex = tex;
    
    
    doMotionUpdate = false;
    
    // get screen size
    Width = self.view.frame.size.width;
    Height = self.view.frame.size.height;
    NSLog(@"screen is %f/%f \n", Width, Height);
    
    // audio layer
    audio = new Audio;
    

    // poll accelerometer data
    motionManager = [[CMMotionManager alloc] init];
    
    [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical toQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * motion, NSError *error){ devMotion = motion; }];  
    
    // to manage events from flares
    //notifCenter = [NSNotificationCenter defaultCenter];
        
    notifCenter = [NSNotificationCenter defaultCenter];
    mainQueue = [NSOperationQueue mainQueue];
    
    [notifCenter addObserver:self selector:@selector(bounceReceived) name:@"bounce" object:nil];
}

- (void)bounceReceived
{
    //NSLog(@"There was a bounce"); 
    audio->samples[0].armPlay();
}    


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
	self.context = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)update
{
    float dt = self.timeSinceLastUpdate;
    
    time += dt;
    
    if (doMotionUpdate) {
        aFlare->G.x = devMotion.attitude.roll * 0.1;
        aFlare->G.y = devMotion.attitude.pitch* 0.1;
        aFlare->update(dt);
    }
    
    
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    /*** clear ***/
    
    glClearColor(0.5f, 0.03f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    /*** setup projection matrix ***/
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(-1, 1, 1.0/aspect, -1.0/aspect, -1, 100);
    
    glMatrixMode(GL_PROJECTION);
    glLoadMatrixf(projectionMatrix.m);
    
    /*** set model + view matrix ***/
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    glDisable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    // normal blending
    //glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    // additive blending
    glBlendFunc(GL_SRC_ALPHA, GL_ONE);
    
    glPushMatrix();
        aFlare->render();
    glPopMatrix();
    
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
     NSLog(@"touched out of loop");
    for(UITouch * touch in touches)
    {
        
        NSLog(@"touched");
        
        doMotionUpdate = false;
        
        CGPoint p = [touch locationInView:self.view];
        GLvertex2f touchPosition = uiview2gl(p, self.view);

        aFlare->position = touchPosition;

        audio->samples[0].recordStart();

    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch * touch in touches)
    {
        CGPoint p = [touch locationInView:self.view];
        GLvertex2f touchPosition = uiview2gl(p, self.view);
        aFlare->position = touchPosition;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch * touch in touches)
    {
        doMotionUpdate = true;
        audio->samples[0].recordStop();
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}



@end
