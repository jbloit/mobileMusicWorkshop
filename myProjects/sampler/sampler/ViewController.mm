//
//  ViewController.m
//  sampler
//
//  Created by Julien Bloit on 14/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#include "Audio.h"

@interface ViewController ()
{
    Audio * audio;
}

@end

@implementation ViewController

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
    audio = new Audio;
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

- (IBAction)sample1_Recstart:(id)sender {
   audio->samples[0].recordStart();
}

- (IBAction)sample1_Recstop:(id)sender{
    audio->samples[0].recordStop();
}

- (IBAction)sample1_play:(id)sender{
    audio->samples[0].armPlay();
}

- (IBAction)sample2_Recstart:(id)sender {
    audio->samples[1].recordStart();
}

- (IBAction)sample2_Recstop:(id)sender{
    audio->samples[1].recordStop();
}

- (IBAction)sample2_play:(id)sender{
    audio->samples[1].armPlay();
}



@end
