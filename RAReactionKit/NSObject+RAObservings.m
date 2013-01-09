//
//  NSObject+RAObservings.m
//  RAReactionKit
//
//  Created by Evadne Wu on 10/10/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import "NSObject+RAObservings.h"
#import "NSObject+RAObservingsPrivate.h"
#import "NSObject+RALifetimeHelper.h"
#import "RALifetimeHelper.h"
#import "RAObservingsHelper.h"

@implementation NSObject (RAObservings)

- (NSMutableArray *) ra_observingsHelperBlocksForKeyPath:(NSString *)aKeyPath {

	NSMutableArray *returnedArray = [self.ra_observingsHelpers objectForKey:aKeyPath];
	
	if (!returnedArray) {
	
		returnedArray = [NSMutableArray array];
		[self.ra_observingsHelpers setObject:returnedArray forKey:aKeyPath];
	
	}
	
	return returnedArray;

}

- (id) ra_observe:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context withBlock:(RAObservingsCallback)block {

	NSParameterAssert(keyPath);
	NSParameterAssert(options);
	NSParameterAssert(block);
	
	id returnedHelper = [[RAObservingsHelper alloc] initWithObserverBlock:block withOwner:self keyPath:keyPath options:options context:context];
	[[self ra_observingsHelperBlocksForKeyPath:keyPath] addObject:returnedHelper];
	
	return returnedHelper;
	

}

- (void) ra_observeObject:(id)target keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context withBlock:(RAObservingsCallback)block {

	id helper = [target ra_observe:keyPath options:options context:context withBlock:block];
	
	__weak NSObject *wSelf = self;
	__weak id wHelper = helper;
	__weak id wTarget = target;
	
	[wSelf ra_performOnDeallocation:^{
		
		if (wHelper) {
			[wTarget ra_removeObservingsHelper:wHelper];
		}
		
	}];

}


- (void) ra_removeObservingsHelper:(id)aHelper {

	RAObservingsHelper *castHelper = (RAObservingsHelper *)aHelper;
	NSParameterAssert([castHelper isKindOfClass:[RAObservingsHelper class]]);
	
	[[self ra_observingsHelperBlocksForKeyPath:castHelper.observedKeyPath] removeObject:castHelper];
	[castHelper kill];

}

- (void) ra_removeObserverBlocksForKeyPath:(NSString *)keyPath {

	[self ra_removeObserverBlocksForKeyPath:keyPath context:nil];

}

- (void) ra_removeObserverBlocksForKeyPath:(NSString *)keyPath context:(void *)context {

	NSMutableArray *allHelpers = [self ra_observingsHelperBlocksForKeyPath:keyPath];
	NSArray *removedHelpers = allHelpers;
	
	if (context) {
		
		removedHelpers = [allHelpers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock: ^ (RAObservingsHelper *aHelper, NSDictionary *bindings) {
			return (BOOL)(aHelper.context == context);
		}]];
		
	}
	
	for (RAObservingsHelper *aHelper in removedHelpers)
		[aHelper kill];

	[allHelpers removeObjectsInArray:removedHelpers];

}

@end
