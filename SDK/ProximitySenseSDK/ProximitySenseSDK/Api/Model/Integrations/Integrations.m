//
//  IntegrationsBootstrapper.m
//  BlueBarSDK
//
//  Created by Vladimir Petrov on 14/12/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import "Integrations.h"
#import "ActionBase.h"
#import "TreasureHuntAchievement.h"
#import "TreasureHuntComplete.h"

#import "ContentManagement.h"
#import "AudienceMonitor.h"

@implementation Integrations

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

+ (Integrations *) instance
{
    static Integrations *_instance = nil;
    
    @synchronized (self)
    {
        if (_instance == nil)
        {
            _instance = [[self alloc] init];
        }
    }
    
    return _instance;
}

+ (ContentManagement *) ContentManagement {
    return [ContentManagement instance];
}

+ (AudienceMonitor *) AudienceMonitor {
    return [AudienceMonitor instance];
}

@end
