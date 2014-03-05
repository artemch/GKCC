//
//  IDPGameCenterManager.h
//  VideoPuzzle
//
//  Created by Vadim Lavrov Viktorovich on 1/20/14.
//  Copyright (c) 2014 IDAP Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDPObservableObject.h"
#import <GameKit/GameKit.h>

@class GKLeaderboard, GKAchievement, GKPlayer;

@protocol IDPGameCenterObserver <NSObject>

@optional
- (void)gameCenderDidAuthenticateWithError:(NSError *)error;
- (void)gemeCenterDidResetScores:(NSArray *)scores withError:(NSError *)error;
- (void)gameCenterDidReportScoreWithError:(NSError *)error;
- (void)gameCenterDidLeaderboardLoadWithError:(NSError *)error;

@end

@interface IDPGameCenterManager : IDPObservableObject
@property (nonatomic, readonly) GKLocalPlayer *currentPlayer;
@property (nonatomic, retain)   GKLeaderboard *currentLeaderBoard;

+ (id)sharedCenterManager;
+ (BOOL)isGameCenterAvailable;
- (void)authenticateLocalUser;

- (void)loadLeaderboardForIdentifier:(NSString *)identifier;
- (void)loadScoresForCurrentLeaderboardWithRange:(NSRange)range;

- (void)authenticateLocalUserWithRootViewController:(UIViewController *)rootViewController;

- (void)reportScore:(int64_t)score forIdentifier:(NSString *)identifier;

- (void)reloadHighScoresForIdentifier:(NSString *)Identifier;

- (void)reloadHighScoresForIdentifier:(NSString *)Identifier
                             forRange:(NSRange)range;

- (void)reloadHighScoresForCurrentLeaderBoardforRange:(NSRange)range;

@end
