//
//  TreasurehHuntLocation.h
//  Trails
//
//  Created by Vladimir Petrov on 13/12/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreasureHuntLocation : NSObject

@property BOOL isMandatoryToWin;
@property BOOL discovered;

@property (nonatomic, copy) NSString* zoneId;

@property (nonatomic, copy) NSString* message;
@property (nonatomic, copy) NSString* locationName;
@property (nonatomic, copy) NSString* locationDescription;
@property (nonatomic, copy) NSString* imageUrl;
@property (nonatomic, copy) NSNumber* latitude;
@property (nonatomic, copy) NSNumber* longitude;
@property (nonatomic, copy) NSString* address;

@end;
