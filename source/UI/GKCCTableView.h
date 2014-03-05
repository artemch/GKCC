//
//  IDPCCTableView.h
//  FloopeyBert
//
//  Created by Artem Chabanniy on 3/3/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GKCCTableView : CCTableView

/**
 By default set to YES.
 */
@property (nonatomic, assign, getter = isClipBounds) BOOL clipBounds;

@end
