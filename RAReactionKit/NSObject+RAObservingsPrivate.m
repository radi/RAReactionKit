//
//  NSObject+RAObservingsPrivate.m
//  RAReactionKit
//
//  Created by Evadne Wu on 10/10/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import "NSObject+RAObservingsPrivate.h"

NSString * const kAssociatedRAObservingsHelpers = @"kAssociatedRAObservingsHelpers";

@implementation NSObject (RAObservingsPrivate)

- (NSMutableDictionary *) ra_observingsHelpers {

	NSMutableDictionary *associatedHelpers = objc_getAssociatedObject(self, &kAssociatedRAObservingsHelpers);
	if (!associatedHelpers) {
		associatedHelpers = [NSMutableDictionary dictionary];
		objc_setAssociatedObject(self, &kAssociatedRAObservingsHelpers, associatedHelpers, OBJC_ASSOCIATION_RETAIN);
	}
	
	return associatedHelpers;

}

@end
