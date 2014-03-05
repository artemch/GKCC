//
//  FBPlayerObject.h
//  FloopeyBert
//
//  Created by Artem Chabanniy on 2/26/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "IDPModel.h"
#import <GameKit/GameKit.h>

@interface GCPlayerObject : IDPModel

@property (nonatomic, retain) GKScore   *score;
@property (nonatomic, retain) GKPlayer  *player;

@end
