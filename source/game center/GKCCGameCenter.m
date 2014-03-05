//
//  FBGameCenter.m
//  FloopeyBert
//
//  Created by Artem Chabanniy on 2/26/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GKCCGameCenter.h"

@interface GKCCGameCenter () <IDPGameCenterObserver>

@property (nonatomic, retain) IDPGameCenterManager  *gameCenterManager;
@property (nonatomic, retain) GCPlayerObject     *currentPlayer;
@property (nonatomic, retain) NSArray               *players;
@property (nonatomic, retain) NSError               *error;
@property (nonatomic, retain) NSArray               *playersInternal;

@end

@implementation GKCCGameCenter

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
    self.gameCenterManager = nil;
    self.currentPlayer = nil;
    self.error = nil;
    self.players = nil;
    self.playersInternal = nil;
    self.leaderboardIdentifier = nil;
    
    [super dealloc];
}


- (id)init {
    self = [super init];
    if (self) {
        self.gameCenterManager = [IDPGameCenterManager sharedCenterManager];
        self.currentPlayer = [[[GCPlayerObject alloc] init] autorelease];
        [self.gameCenterManager addObserver:self];
    }
    return self;
}

#pragma mark -
#pragma mark Public methods

- (void)authenticateWithRootViewController:(UIViewController *)viewController {
    [self.gameCenterManager authenticateLocalUserWithRootViewController:viewController];
}

- (void)submitScore:(NSInteger)score {
    [self.gameCenterManager reportScore:score forIdentifier:self.leaderboardIdentifier];
}

- (void)loadLeaderboardScore {
    [self loadScores];
}

#pragma mark -
#pragma mark Private methods

- (void)loadLeaderboard {
    [self.gameCenterManager loadLeaderboardForIdentifier:self.leaderboardIdentifier];
}

- (void)loadScores {
    NSRange range = NSMakeRange(1, 10);
    [self.gameCenterManager loadScoresForCurrentLeaderboardWithRange:range];
}


#pragma mark -
#pragma mark IDPGameCenterObserver

- (void)gameCenderDidAuthenticateWithError:(NSError *)error {
    self.error = error;
    if (error) {
        NSLog(@"%@",error.localizedDescription);
        [self failLoading];
    } else {
        self.currentPlayer.player = self.gameCenterManager.currentPlayer;
        self.currentPlayer.score = self.gameCenterManager.currentLeaderBoard.localPlayerScore;
        [self finishLoading];
        [self loadLeaderboard];
    }
}

- (void)gemeCenterDidResetScores:(NSArray *)scores withError:(NSError *)error {
    self.error = error;
    if (error) {
        NSLog(@"%@",error.localizedDescription);
        [self notifyObserversOfChanges];
    } else {
        self.players = nil;
        self.playersInternal = nil;
        NSMutableArray *identifers = [NSMutableArray array];
        NSMutableArray *players = [NSMutableArray array];
        for (GKScore *score in scores) {
            GCPlayerObject *player = [[[GCPlayerObject alloc] init] autorelease];
            player.score = score;
            [identifers addObject:score.playerID];
            [players addObject:player];
        }
        self.currentPlayer.score = self.gameCenterManager.currentLeaderBoard.localPlayerScore;
        self.playersInternal = [NSArray arrayWithArray:players];
        [GKPlayer loadPlayersForIdentifiers:identifers withCompletionHandler:^(NSArray *players, NSError *error) {
            NSMutableArray *playersArray = [NSMutableArray arrayWithArray:self.playersInternal];
            for (GKPlayer *player in players) {
                for (GCPlayerObject *playerObject in playersArray) {
                    if ([playerObject.score.playerID isEqualToString:player.playerID]) {
                        playerObject.player = player;
                        [playersArray removeObject:playerObject];
                        break;
                    }
                }
            }
            self.players = self.playersInternal;
            [self notifyObserversOfChanges];
        }];
    }
}

- (void)gameCenterDidReportScoreWithError:(NSError *)error {
    self.error = error;
    if (error) {
        NSLog(@"%@",error.localizedDescription);
        [self notifyObserversOfChanges];
    } else {
        self.currentPlayer.score = self.gameCenterManager.currentLeaderBoard.localPlayerScore;
    }
}

- (void)gameCenterDidLeaderboardLoadWithError:(NSError *)error {
    self.error = error;
    if (error) {
        NSLog(@"%@",error.localizedDescription);
        [self notifyObserversOfChanges];
    } else {
        [self loadScores];
    }
}

@end
