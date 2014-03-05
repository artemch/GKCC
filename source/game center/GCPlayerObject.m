//
//  FBPlayerObject.m
//  FloopeyBert
//
//  Created by Artem Chabanniy on 2/26/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GCPlayerObject.h"

@implementation GCPlayerObject

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
    self.score = nil;
    self.player = nil;
    
    [super dealloc];
}

@end
