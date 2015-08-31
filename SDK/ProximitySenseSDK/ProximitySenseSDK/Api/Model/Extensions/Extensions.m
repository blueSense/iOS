//
//  IntegrationsBootstrapper.m
//  BlueBarSDK
//
//  Created by Vladimir Petrov on 14/12/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import "Extensions.h"
#import "ActionBase.h"
#import "TreasureHuntAchievement.h"
#import "TreasureHuntComplete.h"

#import "ContentManagement.h"
#import "AudienceMonitor.h"

@implementation Extensions

+ (void) registerCommonActionTypes
{
    [ActionBase registerActionType:@"treasureHuntAchievement"
                   withInitializer:^(){
                       return [[TreasureHuntAchievement alloc] init];
                   }];
    
    [ActionBase registerActionType:@"treasureHuntComplete"
                   withInitializer:^(){
                       return [[TreasureHuntComplete alloc] init];
                   }];
}

+ (Extensions *) instance
{
    static Extensions
    *_instance = nil;
    
    @synchronized (self)
    {
        if (_instance == nil)
        {
            _instance = [[self alloc] init];
        }
    }
    
    return _instance;
}

- (ContentManagement *) ContentManagement {
    return [ContentManagement instance];
}

- (AudienceMonitor *) AudienceMonitor {
    return [AudienceMonitor instance];
}

@end
