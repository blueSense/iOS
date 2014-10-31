//
//  ApiSession.h
//  BlueBarSDK
//
//  Created by Vladimir Petrov on 12/09/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiSession : NSObject

@property (nonatomic, copy) NSString *appSpecificId;
@property (nonatomic, copy) NSDictionary *userMetadata;

@end
