//
//  FBGameCenter.h
//  FloopeyBert
//
//  Created by Artem Chabanniy on 2/26/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "IDPModel.h"
#import "IDPGameCenterManager.h"
#import "GCPlayerObject.h"

@interface GKCCGameCenter : IDPModel

@property (nonatomic, retain, readonly) GCPlayerObject  *currentPlayer;
@property (nonatomic, retain, readonly) NSError         *error;
@property (nonatomic, copy)             NSString        *leaderboardIdentifier;

/**
 Players exept current player.
 */
@property (nonatomic, retain, readonly) NSArray *players;

- (void)authenticateWithRootViewController:(UIViewController *)viewController;
- (void)submitScore:(NSInteger)score;

- (void)loadLeaderboard;

@end