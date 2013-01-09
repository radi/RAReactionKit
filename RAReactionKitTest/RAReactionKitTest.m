//
//  RAReactionKitTest.m
//  RAReactionKitTest
//
//  Created by Evadne Wu on 1/9/13.
//  Copyright (c) 2013 Radius. All rights reserved.
//

#import "RAReactionKit.h"
#import "RAReactionKitTest.h"
#import "RAReactionKitTestObject.h"

@implementation RAReactionKitTest

- (NSUInteger) numberOfTestIterationsForTestWithSelector:(SEL)testMethod {

	return 1000;

}

- (void) testExample {
	
	static BOOL finished = NO;
	static NSMutableSet *keepAlive;
	static NSAutoreleasePool *pool;
	
	if (keepAlive) {
		[keepAlive release];
		keepAlive = nil;
	}
	
	if (pool) {
		[pool release];
		pool = nil;
	}
	
	pool = [[NSAutoreleasePool alloc] init];
	keepAlive = [[NSMutableSet set] retain];
	
	RAReactionKitTestObject *observerObject = [[RAReactionKitTestObject new] autorelease];
	RAReactionKitTestObject *targetObject = [[RAReactionKitTestObject new] autorelease];
	
	NSLog(@"observerObject %p", observerObject);
	NSLog(@"targetObject %p", targetObject);
	
	if (observerObject)
		[keepAlive addObject:observerObject];
	
	if (targetObject)
		[keepAlive addObject:targetObject];
	
	__unsafe_unretained void * wKeepAlive = keepAlive;
	__unsafe_unretained void * wObserverObject = observerObject;
	__unsafe_unretained void * wTargetObject = targetObject;
	
	[observerObject ra_observeObject:targetObject keyPath:@"representedObject" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:(void *)nil withBlock:^(NSKeyValueChange kind, id fromValue, id toValue, NSIndexSet *indices, BOOL isPrior) {
		
		NSLog(
			@"%s" "\n"
			@"  kind: %x\n"
			@"  fromValue: %@\n"
			@"  toValue: %@\n"
			@"  indices: %@\n"
			@"  isPrior: %x", __PRETTY_FUNCTION__, kind, fromValue, toValue, indices, isPrior);
		
	}];
	
	observerObject.representedObject = [NSDate date];
	
	NSOperationQueue * const mainQueue = [NSOperationQueue mainQueue];
	
	[mainQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
		
		NSCParameterAssert([NSThread isMainThread]);
		
		dispatch_group_t group = dispatch_group_create();
		dispatch_retain(group);
		
		dispatch_group_enter(group);
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
			if (wObserverObject)
			if (arc4random() % 8)
				[(id)wKeepAlive removeObject:(id)wObserverObject];
			
			NSLog(@"%@", [group debugDescription]);
			dispatch_group_leave(group);
			
		});
		
		dispatch_group_enter(group);
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			
			if (wTargetObject)
			if (arc4random() % 8)
				[(id)wKeepAlive removeObject:(id)wTargetObject];
			
			NSLog(@"%@", [group debugDescription]);
			dispatch_group_leave(group);
			
		});
		
		dispatch_group_wait(group, 1024);
		dispatch_release(group);
		
		finished = YES;
		
	}]];
	
	while (!finished) {
		NSLog(@"RUNNING next run loop");
		[pool drain];
		pool = [[NSAutoreleasePool alloc] init];
		[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
	}

	[(id)wKeepAlive removeAllObjects];
	[pool drain];
	pool = nil;
	
}

@end
