//
//  AudienceMonitor.h
//  ProximitySenseSDK
//
//  Created by Vladimir Petrov on 28/08/2015.
//  Copyright (c) 2015 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendMessageRequest.h"

@interface AudienceMonitor : NSObject

+ (AudienceMonitor *) instance;

- (void) sendMessage:(SendMessageRequest*) messageRequest;
- (void) sendMessage:(SendMessageRequest*) messageRequest withCompletion:(void (^)(NSError *))onCompletion;

@end