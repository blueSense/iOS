//
//  Application.h
//  BlueBarSDK
//
//  Created by Vladimir Petrov on 23/01/2015.
//  Copyright (c) 2015 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Application : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *appDescription;
@property (nonatomic, copy) NSString *clientId;
@property (nonatomic, copy) NSString *privateKey;

@end
