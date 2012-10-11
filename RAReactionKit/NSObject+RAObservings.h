//
//  NSObject+RAObservings.h
//  RAReactionKit
//
//  Created by Evadne Wu on 10/10/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import <objc/objc.h>
#import <objc/runtime.h>
#import <Foundation/Foundation.h>

#import "RAObservings.h"

@interface NSObject (RAObservings)

- (id) ra_observe:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context withBlock:(RAObservingsCallback)block;

- (void) ra_removeObservingsHelper:(id)aHelper;
- (void) ra_removeObserverBlocksForKeyPath:(NSString *)keyPath;
- (void) ra_removeObserverBlocksForKeyPath:(NSString *)keyPath context:(void *)context;

- (NSMutableArray *) ra_observingsHelperBlocksForKeyPath:(NSString *)aKeyPath;

- (void) ra_observeObject:(id)target keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context withBlock:(RAObservingsCallback)block;

@end
