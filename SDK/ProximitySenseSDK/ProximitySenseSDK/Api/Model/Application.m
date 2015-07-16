//
//  Application.m
//  BlueBarSDK
//
//  Created by Vladimir Petrov on 23/01/2015.
//  Copyright (c) 2015 Blue Sense Networks. All rights reserved.
//

#import "Application.h"

@implementation Application

- (NSDictionary*)jsonMapping {
    return @{
             // JSON key : property name
             @"description": @"appDescription"
             };
}

@end
