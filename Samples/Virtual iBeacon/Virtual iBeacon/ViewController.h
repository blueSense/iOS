//
//  ViewController.h
//  Virtual iBeacon
//
//  Created by Vladimir Petrov on 08/10/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController : UIViewController<CBPeripheralManagerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btnStart;
@property (nonatomic) BOOL isStarted;

- (IBAction)onStart:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *uuid;
@property (strong, nonatomic) IBOutlet UITextField *major;
@property (strong, nonatomic) IBOutlet UITextField *minor;

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) NSDictionary *beaconPeripheralData;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;

- (void) startBroadcasting;
- (void) stopBroadcasting;

@end

