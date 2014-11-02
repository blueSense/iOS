//
// Created by Vladimir Petrov on 08/06/2014.
// Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString *RangingResponse;

@interface RangingManager : NSObject < CLLocationManagerDelegate >

+ (RangingManager *) instance;

- (void) startForUuid:(NSString *)uuid;
- (void) stop;


@end