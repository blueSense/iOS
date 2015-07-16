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

@end
