//
//  FSGameDirector.m
//  FlappySmasher
//
//  Created by Artem Chabanniy on 2/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GKCCGameDirector.h"
#import "NSObject+IDPExtensions.h"
#import "NSBundle+GKCCExtension.h"

static NSString *const kFSLeaderboardId = @"com.idap.flappysmasher.score";

static id __gameDirector = nil;

@interface GKCCGameDirector ()

@property (nonatomic, retain) GKCCUserModel     *user;
@property (nonatomic, retain) GKCCGameCenter    *gameCenter;
@property (nonatomic, retain) GKCCSoundEngine   *soundEngine;

@end

@implementation GKCCGameDirector

#pragma mark -
#pragma mark Class methods

+ (id)__sharedObject {
    return __gameDirector;
}

+ (id)sharedObject {
    static dispatch_once_t __gameDirectorUniqueOnceToken;
    dispatch_once(&__gameDirectorUniqueOnceToken, ^{
        __gameDirector = [[self alloc] init];
    });
    
    return __gameDirector;
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
    self.user = nil;
    self.gameCenter = nil;
    self.soundEngine = nil;
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        self.user = [GKCCUserModel object];
        self.gameCenter = [GKCCGameCenter object];
        self.gameCenter.leaderboardIdentifier = kFSLeaderboardId;
        self.soundEngine = [GKCCSoundEngine sharedSoundEngine];
        NSDictionary *dictionary = [NSBundle plistForName:kFSSound];
        if (dictionary) {
            [self.soundEngine setSoundsFromDictionary:dictionary];
            [self.soundEngine preloadBackground];
            [self.soundEngine preloadEffects];
        }
    }
    return self;
}

#pragma mark -
#pragma mark Public methods

@end
