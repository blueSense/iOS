//
//  CalibrateViewController.h
//  BlueBar Configuration Utility
//
//  Created by Vladimir Petrov on 01/10/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetectedBeacon;

@interface CalibrateViewController : UIViewController

@property ( strong, nonatomic ) DetectedBeacon *beacon;

@property (strong, nonatomic) IBOutlet UILabel *beaconName;
@property (strong, nonatomic) IBOutlet UILabel *beaconSerial;
@property (strong, nonatomic) IBOutlet UILabel *rssi;
@property (strong, nonatomic) IBOutlet UIProgressView *progress;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *btnStart;

- (IBAction)startCalibration:(id)sender;

- (IBAction)back:(id)sender;

@end
