//
// Created by Vladimir Petrov on 15/09/2014.
// Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//


#ifndef __NSArray_H_
#define __NSArray_H_

@interface NSArray (myTransformingAddition)
-(NSArray*)transformWithBlock:(id(^)(id))block;
@end

#endif //__NSArray_H_
