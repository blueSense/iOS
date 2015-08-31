//
//  ProximitySenseSDK.m
//  ProximitySenseSDK
//
//  Created by Vladimir Petrov on 16/07/2015.
//  Copyright (c) 2015 Blue Sense Networks. All rights reserved.
//

#import "ProximitySenseSDK.h"

@implementation ProximitySenseSDK

+ (ApiOperations *) Api {
    return [ApiOperations instance];
}

+ (RangingManager *) Ranging {
    return [RangingManager instance];
}

+ (Extensions *) Extensions {
    return [Extensions instance];
}

+ (void)InitializeWithApplicationId:(NSString *)applicationId andPrivateKey:(NSString *)appPrivateKey
{
    [ProximitySenseSDK InitializeWithCredentials:[[ApiCredentials alloc]initWithApplicationId:applicationId andPrivateKey:appPrivateKey]];
}

+ (void)InitializeWithCredentials:(ApiCredentials *)apiCredentials
{
    [ProximitySenseSDK Api].credentials = apiCredentials;
}


@end
