//
//  NSBundle+ATGExtension.h
//  AnotherTossGame
//
//  Created by Artem Chabanniy on 31/10/2013.
//  Copyright (c) 2013 IDAP Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (GKCCExtension)

+ (NSDictionary *)plistForName:(NSString *)plistName;
+ (NSDictionary *)plist:(NSString *)plistName fromKey:(NSString *)key;

+ (NSString *)bundleIdentifer;

@end
