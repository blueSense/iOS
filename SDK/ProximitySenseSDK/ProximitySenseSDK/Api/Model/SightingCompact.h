//
// Created by Vladimir Petrov on 04/10/2015.
// Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sighting.h"

@interface SightingCompact : NSObject

@property ( nonatomic, strong ) NSString * uuid;
@property ( nonatomic, strong ) NSArray * d;

- (id)initFromSighting:(Sighting *)sighting;

@end