//
//  ActionBase.m
//  BlueBarSDK
//
//  Created by Vladimir Petrov on 25/09/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import "ActionBase.h"
#import "ZoneEventDetails.h"
#import "Sighting.h"
#import "ActionResponse.h"
#import "NSObject+BSN_GFJson.h"
#import "RichContentAction.h"

@implementation ActionBase
{
}

+ (NSMutableDictionary*) actionTypes
{
    static NSMutableDictionary* types = nil;
    
    if (types == nil)
    {
        types = [[NSMutableDictionary alloc] init];
    }
    
    return types;
}

+ (id)parseActionResponse:(ActionResponse *)response
{
    id (^initializer)() = (id (^)())[[ActionBase actionTypes] objectForKey:response.type];
    return [initializer() initWithJsonObject:response.result];
}

+ (void)registerActionType:(NSString*)typeName withInitializer:(id (^)()) initializerBlock
{
    id initializer = [[ActionBase actionTypes] objectForKey:typeName];
    if (initializer == nil)
    {
        [[ActionBase actionTypes] setValue:initializerBlock forKey:typeName];
    }
}

+ (void) registerCommonActionTypes
{
    [ActionBase registerActionType:@"richContent"
                   withInitializer:^(){
                       return [[RichContentAction alloc] init];
                   }];
}


@end
