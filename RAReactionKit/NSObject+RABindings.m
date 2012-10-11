//
//  NSObject+RABindings.m
//  RAReactionKit
//
//  Created by Evadne Wu on 10/10/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import <objc/objc.h>
#import <objc/runtime.h>
#import "NSObject+RABindings.h"
#import "RABindings.h"
#import "RABindingsHelper.h"

NSString * const RABindingsMainQueueGravityOption = @"RABindingsMainQueueGravityOption";
NSString * const RABindingsValueTransformerOption = @"RABindingsValueTransformerOption";
NSString * const kRABindingsHelperObject = @"kRABindingsHelperObject";

@implementation NSObject (RABindings)

- (RABindingsHelper *) ra_bindingsHelper {

	RABindingsHelper *associatedHelper = objc_getAssociatedObject(self, &kRABindingsHelperObject);
	
	if (!associatedHelper) {
		associatedHelper = [[RABindingsHelper alloc] init];
		associatedHelper.owner = self;
		objc_setAssociatedObject(self, &kRABindingsHelperObject, associatedHelper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	
	associatedHelper.owner = self;
	
	return associatedHelper;

}

- (void) ra_bind:(NSString *)aKeyPath toObject:(id)anObservedObject keyPath:(NSString *)remoteKeyPath options:(NSDictionary *)options {

	[self ra_unbind:aKeyPath];

	[[self ra_bindingsHelper] ra_bind:aKeyPath toObject:anObservedObject keyPath:remoteKeyPath options:options];

}

- (void) ra_unbind:(NSString *)aKeyPath {

	[[self ra_bindingsHelper] ra_unbind:aKeyPath];

}

@end
