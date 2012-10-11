//
//  NSObject+RALifetimeHelper.m
//  RAReactionKit
//
//  Created by Evadne Wu on 10/10/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import "NSObject+RALifetimeHelper.h"
#import "RALifetimeHelper.h"

static NSString *kRALifetimeHelpers = @"kRALifetimeHelpers";

@implementation NSObject (RALifetimeHelper)

- (void) ra_performOnDeallocation:(void(^)(void))aBlock {
	
	RALifetimeHelper *helper = [RALifetimeHelper helperWithDeallocationCallback:aBlock];
	helper.owner = self;
	
	[[self ra_lifetimeHelpers] addObject:helper];

}

- (NSMutableSet *) ra_lifetimeHelpers {

	NSMutableSet *returnedSet = objc_getAssociatedObject(self, &kRALifetimeHelpers);
	if (returnedSet)
		return returnedSet;
	
	returnedSet = [NSMutableSet set];
	objc_setAssociatedObject(self, &kRALifetimeHelpers, returnedSet, OBJC_ASSOCIATION_RETAIN);
	
	return returnedSet;

}

@end
