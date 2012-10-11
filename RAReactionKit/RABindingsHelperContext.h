//
//  RABindingsHelperContext.h
//  RAReactionKit
//
//  Created by Evadne Wu on 5/23/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RABindings.h"

@interface RABindingsHelperContext : NSObject

- (id) initWithSource:(id)source keyPath:(NSString *)sourceKeyPath target:(id)target keyPath:(NSString *)targetKeyPath options:(NSDictionary *)options;

@end
