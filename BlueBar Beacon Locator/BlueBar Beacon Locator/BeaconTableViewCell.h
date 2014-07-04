//
//  BeaconTableViewCell.h
//  BlueBar Beacon Locator
//
//  Created by Vladimir Petrov on 04/07/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeaconTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *Uuid;
@property (strong, nonatomic) IBOutlet UILabel *Major;
@property (strong, nonatomic) IBOutlet UILabel *Minor;
@property (strong, nonatomic) IBOutlet UILabel *Rssi;
@property (strong, nonatomic) IBOutlet UILabel *Zone;

@end
