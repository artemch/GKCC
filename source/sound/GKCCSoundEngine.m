//
//  IDPGKSoundEngine.m
//  FloopeyBert
//
//  Created by Artem Chabanniy on 2/27/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GKCCSoundEngine.h"
#import "OALSimpleAudio.h"

static id __soundEngine = nil;

@interface GKCCSoundEngine ()

@property (nonatomic, retain) OALSimpleAudio        *simpleAudio;
@property (nonatomic, copy)   NSString              *backgroundSound;
@property (nonatomic, retain) NSMutableDictionary   *effectsCached;
@property (nonatomic, retain) NSDictionary          *effectNames;

@end

@implementation IDPGKSoundEngine

#pragma mark -
#pragma mark Class methods

+ (IDPGKSoundEngine *)sharedSoundEngine {
    static dispatch_once_t __soundEngineOnceToken;
    dispatch_once(&__soundEngineOnceToken, ^{
        __soundEngine = [[self alloc] init];
    });
    
    return __soundEngine;
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
    self.simpleAudio = nil;
    self.backgroundSound = nil;
    self.effectsCached = nil;
    
    [super dealloc];
}

- (id)init {
    static dispatch_once_t onceToken;
    __block id result = self;
    dispatch_once(&onceToken, ^{
    if (!__soundEngine) {
        result = [super init];
        if (self) {
            [self baseInit];
        }
    }
    });
    self = result;
    return self;
}

- (void)baseInit {
    self.simpleAudio = [OALSimpleAudio sharedInstance];
    self.effectsCached = nil;
}

+ (id)allocWithZone:(NSZone *)zone {
    static dispatch_once_t once;
    
    __block id result = __soundEngine;
    
    dispatch_once(&once, ^{
    if (!__soundEngine) {
        result = [super allocWithZone:zone];
    }
    });
    
    return result;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (oneway void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

#pragma mark -
#pragma mark Accessor methods

- (void)setBgPaused:(BOOL)bgPaused {
    self.simpleAudio.bgPaused = bgPaused;
}

- (BOOL)isBgPaused {
    return self.simpleAudio.bgPaused;
}

- (void)setPaused:(BOOL)paused {
    self.simpleAudio.paused = paused;
}

- (BOOL)isPaused {
    return self.simpleAudio.paused;
}

- (void)setEffectsPaused:(BOOL)effectsPaused {
    self.simpleAudio.effectsPaused = effectsPaused;
}

- (BOOL)isEffectsPaused {
    return self.simpleAudio.effectsPaused;
}

#pragma mark -
#pragma mark Public methods

- (void)playBackground {
    [self.simpleAudio playBg:self.backgroundSound loop:YES];
}

- (void)playEffectForName:(NSString *)effectName {
    ALBuffer *effect = [self.effectsCached objectForKey:effectName];
    if (effect) {
        [self.simpleAudio playBuffer:effect volume:self.simpleAudio.effectsVolume pitch:1.0 pan:0.0 loop:NO];
    }
}

- (void)stopPlayBackground {
    [self.simpleAudio stopBg];
}

- (BOOL)preloadBackground {
    return [self.simpleAudio preloadBg:self.backgroundSound];
}

- (void)preloadEffects {
    self.effectsCached = [NSMutableDictionary dictionary];
    for (NSString *key in self.effectNames.allKeys) {
        ALBuffer *buffer = [self.simpleAudio preloadEffect:[self.effectNames objectForKey:key]];
        [self.effectsCached setObject:buffer forKey:key];
    }
}

- (void)setSoundsFromDictionary:(NSDictionary *)sounds {
    self.effectNames = [sounds objectForKey:kIDPGKSounds];
    self.backgroundSound = [sounds objectForKey:kIDPGKBackgroundSound];
}

- (void)stopAllEffects {
    [self.simpleAudio stopAllEffects];
}

- (void)stopEverything {
    [self.simpleAudio stopEverything];
}

@end
