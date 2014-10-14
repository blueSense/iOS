//
//  BeaconsViewController.h
//  BlueBar Service App
//
//  Created by Vladimir Petrov on 01/02/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "BlueBarSDK.h"

@interface BeaconsViewController : UITableViewController<BeaconConnectionDelegate>

@property ( strong, nonatomic ) IBOutlet UIButton *stopScanningButton;

- (IBAction)stopScanning:(id)sender;

- (IBAction)logOut:(id)sender;

@end
