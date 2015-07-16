//
//  ActionBase.h
//  BlueBarSDK
//
//  Created by Vladimir Petrov on 25/09/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZoneEventDetails;
@class Sighting;
@class ActionResponse;

@interface ActionBase : NSObject

@property (nonatomic, strong) NSString* appSpecificId;
@property (nonatomic, strong) NSDate* createdOn;
@property (nonatomic, strong) ZoneEventDetails* zoneEvent;
@property (nonatomic, strong) Sighting* sighting;

+ (id) parseActionResponse:(ActionResponse *)response;

+ (void) registerCommonActionTypes;
+ (void) registerActionType:(NSString*)typeName withInitializer:(id (^)()) initializer;

@end
