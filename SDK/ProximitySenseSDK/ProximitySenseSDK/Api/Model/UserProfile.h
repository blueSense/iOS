//
//  UserProfile.h
//  BlueBarSDK
//
//  Created by Vladimir Petrov on 25/01/2015.
//  Copyright (c) 2015 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject

@property (nonatomic, copy) NSString *entityId;
@property (nonatomic)       BOOL      isActive;
@property (nonatomic, copy) NSString *screenName;
@property (nonatomic, copy) NSString *profileImageUrl;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *website;

@end
