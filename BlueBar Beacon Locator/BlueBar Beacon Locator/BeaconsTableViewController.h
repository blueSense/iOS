//
//  BeaconsTableViewController.h
//  BlueBar Beacon Locator
//
//  Created by Vladimir Petrov on 04/07/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BeaconsTableViewController : UITableViewController <CLLocationManagerDelegate, CBCentralManagerDelegate>

-(void) startForUuid:(NSString *)uuid;

@end
