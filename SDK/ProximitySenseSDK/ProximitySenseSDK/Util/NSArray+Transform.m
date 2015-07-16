//
// Created by Vladimir Petrov on 15/09/2014.
// Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#include "NSArray+Transform.h"

@implementation NSArray (myTransformingAddition)
-(NSArray*)transformWithBlock:(id(^)(id))block{
    NSMutableArray*result=[NSMutableArray array];
    for(id x in self){
        if (x)
            [result addObject:block(x)];
    }
    return result;
}
@end