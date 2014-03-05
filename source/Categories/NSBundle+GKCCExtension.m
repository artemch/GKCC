//
//  NSBundle+ATGExtension.m
//  AnotherTossGame
//
//  Created by Artem Chabanniy on 31/10/2013.
//  Copyright (c) 2013 IDAP Group. All rights reserved.
//

#import "NSBundle+GKCCExtension.h"

@implementation NSBundle (GKCCExtension)

#pragma mark -
#pragma mark Class methods

+ (NSDictionary *)plistForName:(NSString *)plistName {
    NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

+ (NSDictionary *)plist:(NSString *)plistName fromKey:(NSString *)key {
    NSDictionary *dictionary = [NSBundle plistForName:plistName];
    return [NSBundle plistForName:[dictionary objectForKey:key]];
}

+ (NSString *)bundleIdentifer {
    return [[NSBundle mainBundle] bundleIdentifier];
}

@end
