//
//  IDPGameCenterManager.m
//  VideoPuzzle
//
//  Created by Vadim Lavrov Viktorovich on 1/20/14.
//  Copyright (c) 2014 IDAP Group. All rights reserved.
//

#import "IDPGameCenterManager.h"
#import <GameKit/GameKit.h>

@interface IDPGameCenterManager ()
@property (nonatomic, retain) GKLocalPlayer *currentPlayer;
@property (nonatomic, assign) float         version;

@end

@implementation IDPGameCenterManager
@synthesize currentPlayer       = _currentPlayer;
@synthesize currentLeaderBoard  = _currentLeaderBoard;
@synthesize version             = _version;

#pragma mark -
#pragma mark Class Methods

+ (id)sharedCenterManager {
    static IDPGameCenterManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (id)init {
	self = [super init];
	if(self) {
		self.version = [[[UIDevice currentDevice] systemVersion] floatValue];
	}
	return self;
}

- (void)dealloc {
    self.currentPlayer = nil;
    self.currentLeaderBoard = nil;
    [super dealloc];
}


+ (BOOL) isGameCenterAvailable {
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (version > 4.1) {
        return YES;
    }
    return NO;
}


- (void)authenticateLocalUser {
	if([GKLocalPlayer localPlayer].authenticated == NO)	{
		[[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
             [self notifyObserversOnMainThreadWithSelector:@selector(gameCenderDidAuthenticateWithError:) userInfo:error];
        }];
	}
    self.currentPlayer = [GKLocalPlayer localPlayer];
}

- (void)authenticateLocalUserWithRootViewController:(UIViewController *)rootViewController {
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler =
    ^(UIViewController *viewController,
      NSError *error) {
        if (error) {
            [self notifyObserversOnMainThreadWithSelector:@selector(gameCenderDidAuthenticateWithError:) userInfo:error];
        } else {
            if (localPlayer.authenticated) {
                self.currentPlayer = [GKLocalPlayer localPlayer];
                [self notifyObserversOnMainThreadWithSelector:@selector(gameCenderDidAuthenticateWithError:) userInfo:error];
            } else if(viewController) {
                [[CCDirector sharedDirector] pause];
                [rootViewController presentViewController:viewController animated:YES completion:nil];
            }
        }
    };
}


- (void)reloadHighScoresForCurrentLeaderBoardforRange:(NSRange)range {
    NSString *identifier = nil;
    if (self.version >= 7.0) {
       identifier = self.currentLeaderBoard.identifier;
    } else {
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
       identifier = self.currentLeaderBoard.category;
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
    }
    [self reloadHighScoresForIdentifier:identifier forRange:range];
}


- (void)reloadHighScoresForIdentifier:(NSString *)Identifier {
	self.currentLeaderBoard = [[[GKLeaderboard alloc] init] autorelease];
	if (self.version >= 7.0) {
        self.currentLeaderBoard.identifier = Identifier;
    } else {
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        self.currentLeaderBoard.category = Identifier;
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
    }

	self.currentLeaderBoard.range = NSMakeRange(1, 2);
	
	[self.currentLeaderBoard loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
        [self notifyObserversOnMainThreadWithSelector:@selector(gemeCenterDidResetScores: withError:) userInfo:scores error:error];
     }];
}

- (void)loadLeaderboardForIdentifier:(NSString *)identifier {
    [GKLeaderboard loadLeaderboardsWithCompletionHandler:^(NSArray *leaderboards, NSError *error) {
        for (GKLeaderboard *leaderboard in leaderboards) {
            if ([leaderboard.identifier isEqualToString:identifier]) {
                self.currentLeaderBoard = [leaderboards firstObject];
                break;
            }
        }
        [self notifyObserversOnMainThreadWithSelector:@selector(gameCenterDidLeaderboardLoadWithError:) userInfo:error];
    }];
}

- (void)loadScoresForCurrentLeaderboardWithRange:(NSRange)range {
    [self.currentLeaderBoard loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
        [self notifyObserversOnMainThreadWithSelector:@selector(gemeCenterDidResetScores: withError:) userInfo:scores error:error];
    }];
}

- (void)reloadHighScoresForIdentifier:(NSString *)Identifier
                             forRange:(NSRange)range
{
    self.currentLeaderBoard = [[[GKLeaderboard alloc] init] autorelease];
    if (self.version >= 7.0) {
//        self.currentLeaderBoard.identifier = Identifier;
    } else {
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        self.currentLeaderBoard.category = Identifier;
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
    }
    
	self.currentLeaderBoard.range = range;
	
	[self.currentLeaderBoard loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
        [self notifyObserversOnMainThreadWithSelector:@selector(gemeCenterDidResetScores: withError:) userInfo:scores error:error];
    }];
}

- (void)reportScore:(int64_t)score forIdentifier:(NSString *)identifier {
    GKScore *scoreReporter = nil;
    if (self.version >= 7.0) {
        scoreReporter = [[[GKScore alloc] initWithLeaderboardIdentifier:identifier] autorelease];
    } else {
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        scoreReporter = [[[GKScore alloc] initWithCategory:identifier] autorelease];
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
    }

	scoreReporter.value = score;
    [GKScore reportScores:@[scoreReporter] withCompletionHandler:^(NSError *error) {
        [self notifyObserversOnMainThreadWithSelector:@selector(gameCenterDidReportScoreWithError:) userInfo:error];

    }];
}

@end
