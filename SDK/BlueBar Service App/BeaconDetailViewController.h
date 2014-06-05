//
//  BSNDetailViewController.h
//  BlueBar Service App
//
//  Created by Vladimir Petrov on 03/02/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import "DetectedBeacon.h"
#import "BeaconsViewController.h"

@interface BeaconDetailViewController : UIViewController < UISplitViewControllerDelegate, UIAlertViewDelegate >

@property ( strong, nonatomic ) DetectedBeacon *beacon;

@property ( strong, nonatomic ) IBOutlet UILabel *name;
@property ( strong, nonatomic ) IBOutlet UILabel *description;
@property ( strong, nonatomic ) IBOutlet UITextField *uuid;
@property ( strong, nonatomic ) IBOutlet UITextField *major;
@property ( strong, nonatomic ) IBOutlet UITextField *minor;
@property ( strong, nonatomic ) IBOutlet UITextField *signalStrength;
@property ( strong, nonatomic ) IBOutlet UITextField *advInterval;
@property ( strong, nonatomic ) IBOutlet UILabel *status;
@property ( strong, nonatomic ) IBOutlet UISlider *signalStrengthSlider;
@property ( strong, nonatomic ) IBOutlet UISlider *advIntervalSlider;

- (IBAction)refresh:(id)sender;

- (IBAction)update:(id)sender;

- (IBAction)disconnect:(id)sender;

- (IBAction)sliderValueChanged:(UISlider *)sender;

@end
