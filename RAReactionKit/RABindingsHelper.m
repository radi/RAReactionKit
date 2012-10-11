//
//  RABindingsHelper.m
//  RAReactionKit
//
//  Created by Evadne Wu on 5/23/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import "RABindingsHelper.h"
#import "RABindingsHelperContext.h"
#import "RABindings.h"

@interface RABindingsHelper ()

@property (nonatomic, readwrite, retain) NSMutableDictionary *boundLocalKeyPathsToRemoteObjectContexts;

- (RABindingsHelperContext *) contextForBoundKeyPath:(NSString *)keyPath;
- (void) setContext:(RABindingsHelperContext *)context forBoundKeyPath:(NSString *)keyPath;

@end

@implementation RABindingsHelper

@synthesize owner, boundLocalKeyPathsToRemoteObjectContexts;

- (NSMutableDictionary *) boundLocalKeyPathsToRemoteObjectContexts {

	if (!boundLocalKeyPathsToRemoteObjectContexts)
		boundLocalKeyPathsToRemoteObjectContexts = [NSMutableDictionary dictionary];
	
	return boundLocalKeyPathsToRemoteObjectContexts;

}

- (RABindingsHelperContext *) contextForBoundKeyPath:(NSString *)keyPath {
	
	return [self.boundLocalKeyPathsToRemoteObjectContexts objectForKey:keyPath];

}

- (void) setContext:(RABindingsHelperContext *)context forBoundKeyPath:(NSString *)keyPath {

	if (context) {
		
		[self.boundLocalKeyPathsToRemoteObjectContexts setObject:context forKey:keyPath];
		
	} else {
		
		[self.boundLocalKeyPathsToRemoteObjectContexts removeObjectForKey:keyPath];
		
	}

}

- (void) ra_bind:(NSString *)inLocalKeyPath toObject:(id)inRemoteObject keyPath:(NSString *)inRemoteKeyPath options:(NSDictionary *)inOptions {

	RABindingsHelperContext *context = [[RABindingsHelperContext alloc] initWithSource:inRemoteObject keyPath:inRemoteKeyPath target:self.owner keyPath:inLocalKeyPath options:inOptions];
	
	[self setContext:context forBoundKeyPath:inLocalKeyPath];

}

- (void) ra_unbind:(NSString *)inLocalKeyPath {

	[self setContext:nil forBoundKeyPath:inLocalKeyPath];

}

- (void) dealloc {

	for (id aLocalKeyPath in [self.boundLocalKeyPathsToRemoteObjectContexts copy])
		[self ra_unbind:aLocalKeyPath];
	
	self.boundLocalKeyPathsToRemoteObjectContexts = nil;

}

@end
