//
//  ViewController.m
//  fmLab
//
//  Created by Julien Bloit on 13/08/12.
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

- (IBAction)changeFreq:(id)sender
{
    UISlider * slider = (UISlider *)sender;
    audio->setFreq(220+slider.value*220);
}

- (IBAction)changeOsc:(id)sender
{
    UISegmentedControl * tabs = (UISegmentedControl *)sender;
    NSLog(@"oscillator index : %d\n", tabs.selectedSegmentIndex);
    audio->setOscillator(tabs.selectedSegmentIndex);
}

- (IBAction)switchOsc:(id)sender
{
    UISwitch * onoff = (UISwitch *)sender;
    if(onoff.isOn) NSLog(@"oscillator ON \n"); else NSLog(@"oscillator OFF \n");
    audio->setAudio(onoff.isOn);
}

- (IBAction)setModGain:(id)sender
{
    UISlider * slider = (UISlider *)sender;
    NSLog(@"modulation gain %f\n", slider.value);
    audio->setModGain(slider.value * 1000);
}



@end
