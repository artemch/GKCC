//
//  IDPGKSoundEngine.h
//  FloopeyBert
//
//  Created by Artem Chabanniy on 2/27/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kIDPGKBackgroundSound = @"background";
static NSString *const kIDPGKSounds          = @"sounds";

@interface GKCCSoundEngine : NSObject

/** Pauses BG music playback */
@property(nonatomic,readwrite,assign, getter = isBgPaused)  BOOL bgPaused;
/** Pauses everything */
@property(nonatomic,readwrite,assign, getter = isPaused)    BOOL paused;
/** Pauses effects playback */
@property(nonatomic,readwrite,assign, getter = isEffectsPaused) BOOL effectsPaused;

+ (IDPGKSoundEngine *)sharedSoundEngine;

- (BOOL)preloadBackground;
- (void)preloadEffects;

- (void)playBackground;
- (void)stopPlayBackground;

- (void)stopAllEffects;
- (void)stopEverything;

- (void)playEffectForName:(NSString *)effectName;

- (void)setSoundsFromDictionary:(NSDictionary *)sounds;

@end
