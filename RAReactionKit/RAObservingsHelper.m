//
//  RAObservingsHelper.m
//  RAReactionKit
//
//  Created by Evadne Wu on 10/10/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import "RALifetimeHelper.h"
#import "RAObservingsHelper.h"

@implementation RAObservingsHelper

@synthesize owner = _owner;
@synthesize callback = _callback;
@synthesize observedKeyPath = _observedKeyPath;
@synthesize context = _context;
@synthesize lastOldValue = _lastOldValue;
@synthesize lastNewValue = _lastNewValue;

- (id) initWithObserverBlock:(RAObservingsCallback)block withOwner:(id)inOwner keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)inContext {

	self = [super init];
	if (!self)
		return nil;
	
	_owner = inOwner;
	_observedKeyPath = keyPath;
	_callback = block;
	_context = inContext;
	
	__weak typeof(self) wSelf = self;
	
	[_owner addObserver:self forKeyPath:keyPath options:options context:inContext];
	[_owner ra_performOnDeallocation:^{
		[wSelf kill];
	}];
	
	return self;

}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

	id oldValue = change[NSKeyValueChangeOldKey];
	id newValue = change[NSKeyValueChangeNewKey];
	
	if ((self.lastOldValue != (__bridge void *)(oldValue)) || (self.lastNewValue != (__bridge void *)(newValue))) {
	
		NSKeyValueChange changeKind = [change[NSKeyValueChangeKindKey] unsignedIntegerValue];
		NSIndexSet *indices = change[NSKeyValueChangeIndexesKey];
		BOOL isPrior = [change[NSKeyValueChangeNotificationIsPriorKey] boolValue];
		
		id sentOldValue = [oldValue isEqual:[NSNull null]] ? nil : oldValue;
		id sentNewValue = [newValue isEqual:[NSNull null]] ? nil : newValue;
		
		if (self.callback)
			self.callback(changeKind, sentOldValue, sentNewValue, indices, isPrior);
		
		self.lastOldValue = (__bridge void *)(oldValue);
		self.lastNewValue = (__bridge void *)(newValue);
	
	}

}

- (void) kill {

	NSLog(@"%p %s; _owner %p; _observedKeyPath %p; _callback %p", self, __PRETTY_FUNCTION__, _owner, _observedKeyPath, _callback);

	if (_owner && _observedKeyPath)
		[_owner removeObserver:self forKeyPath:_observedKeyPath context:_context];
	
	self.owner = nil;
	self.observedKeyPath = nil;
	self.callback = nil;

}

- (void) dealloc {

	[self kill];

} 

@end
