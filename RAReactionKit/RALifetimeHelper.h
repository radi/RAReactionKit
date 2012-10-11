//
//  RALifetimeHelper.h
//  RAReactionKit
//
//  Created by Evadne Wu on 10/7/11.
//  Copyright (c) 2011 Radius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+RALifetimeHelper.h"

@interface RALifetimeHelper : NSObject

+ (id) helperWithDeallocationCallback:(void(^)(void))aBlock;
@property (nonatomic, readwrite, copy) void (^deallocationCallback)(void);
@property (nonatomic, readwrite, assign) id owner;

@end
