//
//  RAReactionKitTestObject.m
//  RAReactionKit
//
//  Created by Evadne Wu on 1/9/13.
//  Copyright (c) 2013 Radius. All rights reserved.
//

#import "RAReactionKitTestObject.h"

@implementation RAReactionKitTestObject

- (id) init {
	
	self = [super init];
	if (!self)
		return nil;
	
	NSLog(@"%p %s", self, __PRETTY_FUNCTION__);
	
	return self;

}

- (void) dealloc {

	NSLog(@"%p %s", self, __PRETTY_FUNCTION__);
	
	self.representedObject = [NSDate date];	//	trololo
	
	[super dealloc];

}

@end
