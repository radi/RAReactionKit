//
//  RALifetimeHelper.m
//  RAReactionKit
//
//  Created by Evadne Wu on 10/7/11.
//  Copyright (c) 2011 Radius. All rights reserved.
//

#import <objc/objc.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import "RALifetimeHelper.h"

@implementation RALifetimeHelper
@synthesize deallocationCallback, owner;

+ (id) helperWithDeallocationCallback:(void(^)(void))aBlock {

	RALifetimeHelper *returnedHelper = [[self alloc] init];
	returnedHelper.deallocationCallback = aBlock;
	
	return returnedHelper;

}

- (void) dealloc {

	if (deallocationCallback)
		deallocationCallback();
	
}

@end
