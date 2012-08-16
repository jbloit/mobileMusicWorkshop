//
//  ViewController.m
//  fmSimon
//
//  Created by Julien Bloit on 16/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "OSCManager.h"


#include "Audio.h"


@interface ViewController ()

@property (nonatomic, strong) OSCManager *myManager;
@property (nonatomic, strong) OSCOutPort *outPort;
@end

@implementation ViewController


@synthesize myManager;
@synthesize outPort;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.myManager = [[OSCManager alloc] init];
    [self.myManager setDelegate:self];
    
    self.outPort = [[OSCOutPort alloc] initWithAddress:@"127.0.0.1" andPort:12345];
    
    [self.myManager createNewInputForPort:7777];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    


    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(IBAction)playNoteAndSend:(id)sender{

    OSCMessage *msg = [OSCMessage createWithAddress:@"/test/osc1"];
    [msg addFloat:660.0];
    [msg addFloat:0.5];
    
    [self.outPort sendThisMessage:msg];
    
    NSLog(@"message sent!");
    
    
}

- (void) receivedOSCMessage:(OSCMessage *)msg
{
    NSString *addressSpace = msg.address;
    
    NSLog(@"The address space message from is: %@", addressSpace);
}


@end
