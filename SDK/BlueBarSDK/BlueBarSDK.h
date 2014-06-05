//
//  BlueBarSDK.h
//  BlueBarSDK
//
//  Created by Vladimir Petrov on 16/05/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiOperations.h"
#import "BeaconDiscovery.h"

@interface BlueBarSDK : NSObject

+(BeaconDiscovery *) Discovery;
+(ApiOperations*) Api;

@end
