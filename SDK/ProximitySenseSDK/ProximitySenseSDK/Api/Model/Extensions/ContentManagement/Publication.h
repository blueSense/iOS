//
//  Publication.h
//  ProximitySenseSDK
//
//  Created by Vladimir Petrov on 28/08/2015.
//  Copyright (c) 2015 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Publication : NSObject

@property (nonatomic, strong) NSString *title; // Title of the publication
@property (nonatomic, strong) NSString *subtitle; // Subtitle, optional
@property (nonatomic, strong) NSString *identifier; // Identifier, can be used to query for this specific publication
@property (nonatomic, strong) NSString *content; // Raw content
@property (nonatomic, strong) NSString *contentUrl; // a URL to a hosted and styled version of the content - display this in an embedded browser
@property (nonatomic, strong) NSArray *tags; // Array of tags
@property (nonatomic, strong) NSArray *categories;// Array of categories
@property (nonatomic)        BOOL isPublished; // YES if published, NO if still a draft
@property (nonatomic, strong) NSDictionary *userFields; // Name-value pairs with custom fields added by the CMS user

@end
