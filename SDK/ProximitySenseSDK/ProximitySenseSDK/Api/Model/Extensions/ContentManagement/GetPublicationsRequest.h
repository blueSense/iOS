//
//  GetPublicationsRequest.h
//  ProximitySenseSDK
//
//  Created by Vladimir Petrov on 28/08/2015.
//  Copyright (c) 2015 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetPublicationsRequest : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSArray *categories;

@end
