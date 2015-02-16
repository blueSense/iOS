//
// Created by Vladimir Petrov on 08/06/2014.
// Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

extern NSString *RangingResponse;

@interface RangingManager : NSObject < CLLocationManagerDelegate, CBCentralManagerDelegate >

+ (RangingManager *) instance;

- (void) startForUuid:(NSString *)uuid;
- (void) stop;

- (void) lookAroundFor:(NSInteger)seconds completion:(void (^)(UIBackgroundFetchResult fetchResult))completionHandler;

@end