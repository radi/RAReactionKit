//
//  RABindingsHelperContext.m
//  RAReactionKit
//
//  Created by Evadne Wu on 5/23/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import "RABindingsHelperContext.h"
#import "RALifetimeHelper.h"

@interface RABindingsHelperContext ()

@property (nonatomic, readwrite, weak) id source;
@property (nonatomic, readwrite, copy) NSString *sourceKeyPath;

@property (nonatomic, readwrite, weak) id target;
@property (nonatomic, readwrite, copy) NSString *targetKeyPath;

@property (nonatomic, readwrite, assign) BOOL assignsOnMainThread;
@property (nonatomic, readwrite, copy) RABindingsValueTransformer valueTransformer;

@property (nonatomic, readwrite, assign) BOOL dead;
@property (nonatomic, readwrite, assign) const void * sourcePtr;

- (void) dieIfAppropriate;

@end


@implementation RABindingsHelperContext

@synthesize source, sourceKeyPath, target, targetKeyPath, assignsOnMainThread, valueTransformer;
@synthesize dead, sourcePtr;

- (id) initWithSource:(id)inSource keyPath:(NSString *)inSourceKeyPath target:(id)inTarget keyPath:(NSString *)inTargetKeyPath options:(NSDictionary *)inOptions {

	NSCParameterAssert(inSource);
	NSCParameterAssert(inSourceKeyPath);
	NSCParameterAssert(inTarget);
	NSCParameterAssert(inTargetKeyPath);
	
	self = [super init];
	if (!self)
		return nil;
		
	self.source = inSource;
	self.sourceKeyPath = inSourceKeyPath;
	self.target = inTarget;
	self.targetKeyPath = inTargetKeyPath;
	self.assignsOnMainThread = [[inOptions objectForKey:RABindingsMainQueueGravityOption] boolValue];
	self.valueTransformer = [inOptions objectForKey:RABindingsValueTransformerOption];
	
	[self.source addObserver:self forKeyPath:self.sourceKeyPath options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:(__bridge void *)self];
	
	self.sourcePtr = (__bridge const void *)inSource;
	
	__weak RABindingsHelperContext *wSelf = self;
	
	[self.source ra_performOnDeallocation:^{
	
		[wSelf dieIfAppropriate];
	
	}];
	
	[self.target ra_performOnDeallocation:^{
	
		[wSelf dieIfAppropriate];
		
	}];
	
	return self;

}

- (id) init {

	return [self initWithSource:nil keyPath:nil target:nil keyPath:nil options:nil];

}

- (void) dieIfAppropriate {

	if (!self.dead) {
	
		id usedSource = self.source ? self.source : (__bridge id)self.sourcePtr;
		[usedSource removeObserver:self forKeyPath:self.sourceKeyPath context:(__bridge void *)self];
		
		self.dead = YES;

	}

}

- (void) dealloc {
	
	[self dieIfAppropriate];

}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

	if (!self.source) {
	
		//	Concurrent Core Data entity accesses — writing from background thread / queue on alternate context,
		//	then merging on main queue can trigger stray notification
		
		//	Also, with zombies enabled, associated objects aren’t really cleaned up
	
		[self dieIfAppropriate];
		return;
	
	}

	id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
	id newValue = [change objectForKey:NSKeyValueChangeNewKey];
	NSString *changeKind = [change objectForKey:NSKeyValueChangeKindKey];
	id setValue = newValue;
		
	RABindingsValueTransformer valueTransformerOrNil = self.valueTransformer;
	if (valueTransformerOrNil)
		setValue = valueTransformerOrNil(oldValue, newValue, changeKind);
	
	BOOL assignmentOnMainThread = self.assignsOnMainThread;

	if ([setValue isEqual:[NSNull null]])
		setValue = nil;

	id ownerRef = self.target;
	NSString *capturedKeyPath = self.targetKeyPath;
	void (^operation)() = ^ {
		[ownerRef setValue:setValue forKeyPath:capturedKeyPath];
	};

	if (assignmentOnMainThread && ![NSThread isMainThread])
		dispatch_async(dispatch_get_main_queue(), operation);
	else
		operation();

}

- (NSString *) description {

	return [NSString stringWithFormat:@"<%@: 0x%x { %@ %@ -> %@ %@ }>", NSStringFromClass([self class]), (unsigned int)self, self.source, self.sourceKeyPath, self.target, self.targetKeyPath];

}


@end
