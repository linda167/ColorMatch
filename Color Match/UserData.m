//
//  UserData.m
//  Color Match
//
//  Created by Linda Chen on 6/8/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "UserData.h"

static NSString *const LastLevelCompletedInWorldKey = @"LastLevelCompletedInWorld";

@implementation UserData

- (id)init
{
    self = [super init];
    if (self)
    {
        self.userData = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

+(id)sharedUserData
{
    static UserData *sharedUserData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUserData = [[self alloc] init];
    });
    return sharedUserData;
}

+(NSMutableString*)getLevelString:(int)worldId levelId:(int)levelId
{
    NSMutableString *levelString = [[NSMutableString alloc] init];
    [levelString appendString:[NSString stringWithFormat: @"%d-", worldId]];
    [levelString appendString:[NSString stringWithFormat: @"%d", levelId]];
    return  levelString;
}

+(NSMutableString*)getTutorialKeyString:(int)worldId
{
    NSMutableString *tutorialString = [[NSMutableString alloc] init];
    [tutorialString appendString:@"tutorial-"];
    [tutorialString appendString:[NSString stringWithFormat: @"%d", worldId]];
    return tutorialString;
}

-(void)storeLevelComplete:(int)worldId levelId:(int)levelId stars:(int)stars
{
    int currentStarCount = [self getStarCount:worldId levelId:levelId];
    NSMutableString *levelString = [UserData getLevelString:worldId levelId:levelId];
    
    // Don't overwrite higher star count
    if (stars > currentStarCount)
    {
        [self.userData setInteger:stars forKey:levelString];
    }
    
    // Store last level complete
    [self.userData setInteger:worldId forKey:LastLevelCompletedInWorldKey];
    [self.userData synchronize];
}

-(int)getLastLevelCompletedInWorld
{
    return (int)[self.userData integerForKey:LastLevelCompletedInWorldKey];
}

-(bool)getLevelCompleteState:(int)worldId levelId:(int)levelId
{
    NSMutableString *levelString = [UserData getLevelString:worldId levelId:levelId];
    NSInteger isComplete = [self.userData integerForKey:levelString];
    return (int)isComplete >= 1;
}

-(void)storeTutorialComplete:(int)worldId
{
    NSMutableString *tutorialString = [UserData getTutorialKeyString:worldId];
    [self.userData setInteger:1 forKey:tutorialString];
}

-(bool)getTutorialComplete:(int)worldId
{
    NSMutableString *tutorialString = [UserData getTutorialKeyString:worldId];
    return [self.userData integerForKey:tutorialString] == 1;
}

-(void)storeGamePurchased:(bool)purchased
{
    int val = purchased ? 1 : 0;
    [self.userData setInteger:val forKey:@"GamePurchased"];
}

-(bool)getGamePurchased
{
    return [self.userData integerForKey:@"GamePurchased"] == 1;
}

-(void)storeIsSoundEnabled:(bool)enabled
{
    int val = enabled ? 1 : 0;
    [self.userData setInteger:val forKey:@"SoundEnabled"];
}

-(bool)getIsSoundEnabled
{
    NSDictionary *dictionary = [self.userData dictionaryRepresentation];
    
    if ([dictionary objectForKey:@"SoundEnabled"])
    {
        return [self.userData integerForKey:@"SoundEnabled"] == 1;
    }
    else
    {
        // Key is not set, return default initial value
        return true;
    }
}

-(void)storeIsMusicEnabled:(bool)enabled
{
    int val = enabled ? 1 : 0;
    [self.userData setInteger:val forKey:@"MusicEnabled"];
}

-(bool)getIsMusicEnabled
{
    NSDictionary *dictionary = [self.userData dictionaryRepresentation];
    
    if ([dictionary objectForKey:@"MusicEnabled"])
    {
        return [self.userData integerForKey:@"MusicEnabled"] == 1;
    }
    else
    {
        // Key is not set, return default initial value
        return true;
    }
}

-(bool)isFirstFourLevelsOfWorldCompleted:(int)worldId
{
    return [self getLevelCompleteState:worldId levelId:1] &&
        [self getLevelCompleteState:worldId levelId:2] &&
        [self getLevelCompleteState:worldId levelId:3] &&
        [self getLevelCompleteState:worldId levelId:4];
}

-(bool)getIsWorldLocked:(int)worldId
{
    bool gamePurchased = [self getGamePurchased];
    
    int previousWorldId = worldId - 1;
    if (worldId == 1)
    {
        return false;
    }
    else if (worldId > 1 && worldId < 10)
    {
        // The world is unlocked if first four levels of previous world are complete
        return ![self isFirstFourLevelsOfWorldCompleted:previousWorldId];
    }
    else if (worldId == 10)
    {
        if (!gamePurchased)
        {
            // World 10 is locked if game not purchased
            return true;
        }
        else
        {
            return ![self isFirstFourLevelsOfWorldCompleted:previousWorldId];
        }
    }
    
    return false;
}

-(bool)getIsLevelLocked:(int)worldId levelId:(int)levelId
{
    if ([self getIsWorldLocked:worldId])
    {
        return true;
    }
    
    bool gamePurchased = [self getGamePurchased];
    int previousLevelId = levelId - 1;
    
    if (levelId == 1)
    {
        return false;
    }
    else if (levelId > 1 && levelId <= 4)
    {
        return ![self getLevelCompleteState:worldId levelId:previousLevelId];
    }
    else // Level greater than 4
    {
        if (!gamePurchased && worldId > 2)
        {
            // Demo version only first 2 worlds can be fully unlocked
            return true;
        }
        else
        {
            // Otherwise all levels are unlocked if first 4 levels are complete
            return ![self getLevelCompleteState:worldId levelId:4];
        }
    }
}

-(NSString*)getLevelLockedMessage:(int)worldId levelId:(int)levelId isFromPreviousLevel:(bool)isFromPreviousLevel
{
    assert([self getIsLevelLocked:worldId levelId:levelId]);
    
    NSString* mustCompletePreviousWorld = @"You must complete the first four levels of the previous world to unlock levels in this world.";
    
    NSString* mustCompletePreviousLevel = @"You must complete the previous level to unlock this level.";
    
    NSString* mustCompleteFirstFourLevel = @"You must complete the first four levels of this world to unlock this level.";
    
    NSString* mustPurchaseFullGame = isFromPreviousLevel ?
        @"You must purchase the full game to unlock the next level." :
        @"You must purchase the full game to unlock this level.";
    
    bool gamePurchased = [self getGamePurchased];
    if (gamePurchased)
    {
        if ([self getIsWorldLocked:worldId])
        {
            return mustCompletePreviousWorld;
        }
        else if (levelId > 1 && levelId <= 4)
        {
            return mustCompletePreviousLevel;
        }
        else
        {
            return mustCompleteFirstFourLevel;
        }
    }
    else
    {
        if (worldId == 10)
        {
            return mustPurchaseFullGame;
        }
        else if (levelId >= 1 && levelId <= 4)
        {
            // First 4 levels, must complete previous world's first four levels
            return [self getIsWorldLocked:worldId] ?mustCompletePreviousWorld :
                mustCompletePreviousLevel;
        }
        else
        {
            return worldId <= 2 ?
                mustCompleteFirstFourLevel :
                mustPurchaseFullGame;
        }
    }
}

-(int)getStarCount:(int)worldId levelId:(int)levelId
{
    NSMutableString *levelString = [UserData getLevelString:worldId levelId:levelId];
    NSInteger starCount = [self.userData integerForKey:levelString];
    return (int)starCount;
}

-(void)wipeData
{
    NSDictionary *dictionary = [self.userData dictionaryRepresentation];
    
    for (id key in dictionary)
    {
        [self.userData removeObjectForKey:key];
    }
    
    [self.userData synchronize];
}

@end
