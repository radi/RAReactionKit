//
//  RAObservingsHelper.m
//  RAReactionKit
//
//  Created by Evadne Wu on 10/10/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import "RAObservingsHelper.h"

@implementation RAObservingsHelper

@synthesize owner, callback, observedKeyPath, context;
@synthesize lastOldValue, lastNewValue;

- (id) initWithObserverBlock:(RAObservingsCallback)block withOwner:(id)inOwner keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)inContext {

	self = [super init];
	if (!self) return nil;
	
	self.owner = inOwner;
	self.observedKeyPath = keyPath;
	self.callback = block;
	self.context = inContext;
	
	[self.owner addObserver:self forKeyPath:keyPath options:options context:inContext];
	
	return self;

}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

	id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
	id newValue = [change objectForKey:NSKeyValueChangeNewKey];
	
	if ((self.lastOldValue != (__bridge void *)(oldValue)) || (self.lastNewValue != (__bridge void *)(newValue))) {
	
		NSKeyValueChange changeKind = NSKeyValueChangeSetting;
		NSIndexSet *indices = [change objectForKey:NSKeyValueChangeIndexesKey];
		BOOL isPrior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] isEqual:(id)kCFBooleanTrue];
		
		[[change objectForKey:NSKeyValueChangeKindKey] getValue:&changeKind];
		
		id sentOldValue = [oldValue isEqual:[NSNull null]] ? nil : oldValue;
		id sentNewValue = [newValue isEqual:[NSNull null]] ? nil : newValue;
		
		if (self.callback)
			self.callback(changeKind, sentOldValue, sentNewValue, indices, isPrior);
		
		self.lastOldValue = (__bridge void *)(oldValue);
		self.lastNewValue = (__bridge void *)(newValue);
	
	}

}

- (void) kill {

	if (owner && observedKeyPath)
		[owner removeObserver:self forKeyPath:observedKeyPath];
	
	self.owner = nil;
	self.observedKeyPath = nil;
	self.callback = nil;

}

- (void) dealloc {

	[self kill];

} 

@end
