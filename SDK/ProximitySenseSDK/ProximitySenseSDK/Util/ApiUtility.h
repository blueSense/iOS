//
// Created by Vladimir Petrov on 15/09/2014.
// Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiUtility : NSObject

+ (NSString*)computeSHA256DigestForString:(NSString*)input;
+ (BOOL)isResponseSuccessful:(NSURLResponse*)response;
+ (BOOL)isResponseFailed:(NSURLResponse*)response;

@end
