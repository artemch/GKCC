//
//  IDPCCTableView.m
//  FloopeyBert
//
//  Created by Artem Chabanniy on 3/3/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "IDPCCTableView.h"

@interface GKCCTableView ()

@property (nonatomic, assign) CGFloat contentScaleFactor;

@end

@implementation GKCCTableView

#pragma mark -
#pragma mark Initializations and Deallocations

- (id)init
{
    self = [super init];
    if (self) {
        self.contentScaleFactor = [[CCDirector sharedDirector] contentScaleFactor];
        self.clipBounds = YES;
    }
    return self;
}

#pragma mark -
#pragma mark Public methods

- (void)visit {
    if (self.isClipBounds) {
        kmGLPushMatrix();
        glEnable(GL_SCISSOR_TEST);
        CGRect rect = self.boundingBox;
        rect.origin = [self convertToWorldSpace:rect.origin];
        
        glScissor(rect.origin.x * self.contentScaleFactor,
                  rect.origin.y * self.contentScaleFactor,
                  CGRectGetWidth(rect) * self.contentScaleFactor,
                  CGRectGetHeight(rect) * self.contentScaleFactor);
        
        [super visit];
        
        glDisable(GL_SCISSOR_TEST);
        kmGLPopMatrix();
    } else {
        [super visit];
    }
}

@end
