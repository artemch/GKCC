//
//  FSGameDirector.h
//  FlappySmasher
//
//  Created by Artem Chabanniy on 2/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "IDPSingletonModel.h"
#import "GKCCUserModel.h"
#import "GKCCGameCenter.h"
#import "GKCCSoundEngine.h"

@interface GKCCGameDirector : IDPSingletonModel

@property (nonatomic, retain, readonly) GKCCUserModel   *user;
@property (nonatomic, retain, readonly) GKCCGameCenter  *gameCenter;
@property (nonatomic, retain, readonly) GKCCSoundEngine *soundEngine;

@end
