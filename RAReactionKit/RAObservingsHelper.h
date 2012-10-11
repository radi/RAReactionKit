//
//  RAObservingsHelper.h
//  RAReactionKit
//
//  Created by Evadne Wu on 10/10/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RAObservings.h"

@interface RAObservingsHelper : NSObject

- (id) initWithObserverBlock:(RAObservingsCallback)block withOwner:(id)owner keyPath:(NSString *)keypath options:(NSKeyValueObservingOptions)options context:(void *)context;

@property (nonatomic, readwrite, assign) id owner;
@property (nonatomic, readwrite, copy) RAObservingsCallback callback;
@property (nonatomic, readwrite, copy) NSString *observedKeyPath;
@property (nonatomic, readwrite, assign) void *context;

@property (nonatomic, readwrite, assign) void *lastOldValue;
@property (nonatomic, readwrite, assign) void *lastNewValue;

- (void) kill;


@end
