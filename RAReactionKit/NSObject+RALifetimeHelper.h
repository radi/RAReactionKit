//
//  NSObject+RALifetimeHelper.h
//  RAReactionKit
//
//  Created by Evadne Wu on 10/10/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

@interface NSObject (RALifetimeHelper)

- (void) ra_performOnDeallocation:(void(^)(void))aBlock;
- (NSMutableSet *) ra_lifetimeHelpers;

@end
