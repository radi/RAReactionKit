//
//  NSObject+RAObservingsDeprecated.m
//  RAReactionKit
//
//  Created by Evadne Wu on 10/10/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import "NSObject+RAObservings.h"
#import "NSObject+RAObservingsDeprecated.h"
#import "RAObservings.h"

@implementation NSObject (RAObservingsDeprecated)

- (id) irAddObserverBlock:(IRObservingsLegacyCallbackBlock)aBlock forKeyPath:(NSString *)aKeyPath options:(NSKeyValueObservingOptions)options context:(void *)context {

	NSParameterAssert(aBlock);
	NSParameterAssert(aKeyPath);
	NSParameterAssert(options);
	
	return [self ra_observe:aKeyPath options:options context:context withBlock:^(NSKeyValueChange kind, id fromValue, id toValue, NSIndexSet *indices, BOOL isPrior) {
	
		aBlock(fromValue, toValue, kind);
		
	}];

}

@end
