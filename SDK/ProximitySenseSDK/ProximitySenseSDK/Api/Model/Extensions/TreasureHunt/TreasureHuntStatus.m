//
//  TreasureHuntStatus.m
//  Trails
//
//  Created by Vladimir Petrov on 13/12/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import "TreasureHuntStatus.h"
#import "TreasureHuntLocation.h"

@implementation TreasureHuntStatus
- (NSDictionary*)jsonClasses {
    return @{
             @"locations" : [TreasureHuntLocation class]
             };
}
@end
