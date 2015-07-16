//
//  TreasureHuntStatus.h
//  Trails
//
//  Created by Vladimir Petrov on 13/12/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreasureHuntStatus : NSObject

@property (nonatomic, copy) NSString* winMessage;
@property (nonatomic, strong) NSArray* locations;

@end;
