//
//  ContentManagement.h
//  ProximitySenseSDK
//
//  Created by Vladimir Petrov on 28/08/2015.
//  Copyright (c) 2015 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetPublicationsRequest.h"
#import "Publication.h"

@interface ContentManagement : NSObject

+ (ContentManagement *) instance;

- (void) getPublications: (void (^)(NSArray* publications, NSError* connectionError)) onCompletion;
- (void) getPublications: (void (^)(NSArray* publications, NSError* connectionError)) onCompletion withQuery: (GetPublicationsRequest*)getPublicationsRequest;

@end;
