//
//  ApiCredentials.h
//  BlueBar Service App
//
//  Created by Vladimir Petrov on 23/02/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiCredentials : NSObject

- (id) initWithApplicationId:(NSString *)applicationId andPrivateKey:(NSString *)privateKey;

@property (nonatomic, copy) NSString *applicationId;

@property (nonatomic, copy) NSString *clientId;
@property (nonatomic, copy) NSString *privateKey;

@end
