//
//  Publication.h
//  ProximitySenseSDK
//
//  Created by Vladimir Petrov on 28/08/2015.
//  Copyright (c) 2015 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Publication : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *contentUrl;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic)        BOOL isPublished;
@property (nonatomic, strong) NSDictionary *userFields;

@end
