//
//  RichContentAction.h
//  BlueBarSDK
//
//  Created by Vladimir Petrov on 16/01/2015.
//  Copyright (c) 2015 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionBase.h"

@interface RichContentAction : ActionBase

@property (nonatomic) BOOL sendNotification;
@property (nonatomic, strong) NSString *notificationText;
@property (nonatomic) BOOL sendContent;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *contentUrl;

@property (nonatomic, strong) NSDictionary *metadata;


@end
