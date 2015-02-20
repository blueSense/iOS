//
//  ApiConnector.h
//  Trails
//
//  Created by Vladimir Petrov on 13/12/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Application;

@interface ApiConnector : NSObject

    + (ApiConnector*) instance;

    @property (nonatomic, strong) NSArray* applications;

    - (void) registerNotifications;
    - (void) loadApplications;
    - (void) startForApp:(Application*)app;

@end
