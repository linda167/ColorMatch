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
