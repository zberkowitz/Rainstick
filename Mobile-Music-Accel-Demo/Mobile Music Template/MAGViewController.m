//
//  MAGViewController.m
//  Mobile Music Template
//
//  Created by Jesse Allison on 10/17/12.
//  Copyright (c) 2012 MAG. All rights reserved.
//

#import "MAGViewController.h"

@interface MAGViewController ()

@end



@implementation MAGViewController

- (NSUInteger) supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskLandscapeRight;
    
}


#pragma mark - View lifecycle

void scale_setup();

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	
    // _________________ LOAD Pd Patch ____________________
    dispatcher = [[PdDispatcher alloc] init];
    [PdBase setDelegate:dispatcher];
    scale_setup();
    patch = [PdBase openFile:@"mag_template.pd" path:[[NSBundle mainBundle] resourcePath]];
    if (!patch) {
        NSLog(@"Failed to open patch!");
    }
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval  = 1.0/20.0; // Update at 20Hz
    if (self.motionManager.accelerometerAvailable) {
        NSLog(@"Accelerometer avaliable");
        NSOperationQueue *queue = [NSOperationQueue currentQueue];
        [self.motionManager startAccelerometerUpdatesToQueue:queue
                                                 withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                CMAcceleration acceleration = accelerometerData.acceleration;
                                    
                                                [PdBase sendFloat:acceleration.y toReceiver:@"density"];
                                 
                                            }];
    }

}

/*
- (void)viewDidUnload
{
    // uncomment for pre-iOS 6 deployment
    [super viewDidUnload];
    [PdBase closeFile:patch];
    [PdBase setDelegate:nil];
}
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// _________________ UI Interactions with Pd Patch ____________________

@end
