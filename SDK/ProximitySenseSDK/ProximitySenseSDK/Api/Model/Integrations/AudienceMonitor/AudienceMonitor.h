//
//  AudienceMonitor.h
//  ProximitySenseSDK
//
//  Created by Vladimir Petrov on 28/08/2015.
//  Copyright (c) 2015 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudienceMonitor : NSObject

+ (AudienceMonitor *) instance;

- (void) sendRequest: (void (^)(NSError* connectionError)) onCompletion;

@end