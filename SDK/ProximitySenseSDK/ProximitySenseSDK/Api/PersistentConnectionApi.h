//
//  PersistentConnectionApi.h
//  ProximitySenseSDK
//
//  Created by Vladimir Petrov on 31/12/2015.
//  Copyright © 2015 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiCredentials.h"

@interface PersistentConnectionApi : NSObject

- (void) startWithUrl:(NSString*)apiBaseUrl andCredentials:(ApiCredentials*)credentials;
- (void) sendMessage:(NSObject*)message;
- (void) close;

@property (nonatomic, readonly) BOOL isConnected;

@end