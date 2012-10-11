//
//  RABindingsHelper.h
//  RAReactionKit
//
//  Created by Evadne Wu on 5/23/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RABindingsHelper : NSObject

@property (nonatomic, readwrite, weak) id owner;

- (void) ra_bind:(NSString *)aKeyPath toObject:(id)anObservedObject keyPath:(NSString *)remoteKeyPath options:(NSDictionary *)options;
- (void) ra_unbind:(NSString *)aKeyPath;

@end
