//
//  NSObject+RABindings.h
//  RAReactionKit
//
//  Created by Evadne Wu on 10/10/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const RABindingsMainQueueGravityOption;	//	if -isEqual:kCFBooleanTrue, dispatch_async on main queue if ![NSThread isMainThread]
extern NSString * const RABindingsValueTransformerOption;	//	If given block, runs value thru block
typedef id (^RABindingsValueTransformer) (NSDictionary *change, NSKeyValueChange kind, id fromValue, id toValue);

@interface NSObject (RABindings)

- (void) ra_bind:(NSString *)aKeyPath toObject:(id)anObservedObject keyPath:(NSString *)remoteKeyPath options:(NSDictionary *)options;
- (void) ra_unbind:(NSString *)aKeyPath;

@end
