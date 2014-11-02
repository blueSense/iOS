//
// Created by Vladimir Petrov on 25/09/2014.
// Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ActionBase;


@interface ActionResponse : NSObject

@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSDictionary* result;

@end