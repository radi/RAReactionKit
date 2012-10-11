//
//  RAObservings.h
//  RAReactionKit
//
//  Created by Evadne Wu on 2/8/11.
//  Copyright 2011 Radius. All rights reserved.
//

typedef void (^RAObservingsCallback) (NSKeyValueChange kind, id fromValue, id toValue, NSIndexSet *indices, BOOL isPrior);

#import "NSObject+RAObservings.h"
