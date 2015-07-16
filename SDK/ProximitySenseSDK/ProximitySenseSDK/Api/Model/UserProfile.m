//
//  UserProfile.m
//  BlueBarSDK
//
//  Created by Vladimir Petrov on 25/01/2015.
//  Copyright (c) 2015 Blue Sense Networks. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile


- (NSDictionary*)jsonMapping {
    return @{
             // JSON key : property name
             @"id": @"entityId"
             };
}

@end
