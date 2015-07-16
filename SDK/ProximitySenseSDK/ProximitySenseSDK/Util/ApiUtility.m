//
// Created by Vladimir Petrov on 15/09/2014.
// Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <CommonCrypto/CommonHMAC.h>
#include "ApiUtility.h"

@implementation ApiUtility

+ (NSString*)computeSHA256DigestForString:(NSString*)input
{
    const char *stringUsingEncoding = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:stringUsingEncoding length:input.length];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];

    // This is an iOS5-specific method.
    // It takes in the data, how much data, and then output format, which in this case is an int array.
    CC_SHA256(data.bytes, data.length, digest);

    // Setup our Objective-C output.
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];

    // Parse through the CC_SHA256 results (stored inside of digest[]).
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

+ (BOOL)isResponseSuccessful:(NSURLResponse*)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    long responseStatusCode = [httpResponse statusCode];

    if (responseStatusCode >= 200 && responseStatusCode < 300)
        return YES;

    return NO;
}

+ (BOOL)isResponseFailed:(NSURLResponse*)response
{
    return ![ApiUtility isResponseSuccessful:response];
}

@end