//
//  UserData.m
//  Color Match
//
//  Created by Linda Chen on 6/8/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "UserData.h"
#import "SoundManager.h"

static NSString *const LastLevelCompletedInWorldKey = @"LastLevelCompletedInWorld";

@implementation UserData

- (id)init
{
    self = [super init];
    if (self)
    {
        self.userData = [NSUserDefaults standardUserDefaults];
        self.musicTracks = [[NSArray alloc] initWithObjects:
            @"Random",
            @"Crazy Candy Highway",
            @"Curious",
            @"Happy Tune",
            nil];
        
        // Listen for sound finish playing
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(soundDidFinishPlaying:) name:@"SoundDidFinishPlayingNotification" object:nil];
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
    [self storeLastLevelCompletedInWorld:worldId];
    [self.userData synchronize];
}

-(void)storeLastLevelCompletedInWorld:(int)worldId
{
    [self.userData setInteger:worldId forKey:LastLevelCompletedInWorldKey];
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

-(void)storeMusicSelection:(NSString*)musicSelection
{
    [self.userData setObject:musicSelection forKey:@"MusicSelection"];
}

-(NSString*)getMusicSelection
{
    NSDictionary *dictionary = [self.userData dictionaryRepresentation];
    
    if ([dictionary objectForKey:@"MusicSelection"])
    {
        return [self.userData valueForKey:@"MusicSelection"];
    }
    else
    {
        // Key is not set, return default initial value
        return [[self musicTracks] objectAtIndex:0];
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
    int previousWorldId = worldId - 1;
    if (worldId == 1)
    {
        return false;
    }
    else if (worldId > 1 && worldId <= 10)
    {
        // The world is unlocked if first four levels of previous world are complete
        return ![self isFirstFourLevelsOfWorldCompleted:previousWorldId];
    }
    else
    {
        // Worlds 11+ are unlocked if first four levels of world 9 are unlocked, which means they unlocked all mechanics
        return ![self isFirstFourLevelsOfWorldCompleted:9];
    }
    
    return false;
}

-(bool)getIsLevelLocked:(int)worldId levelId:(int)levelId
{
    if ([self getIsWorldLocked:worldId])
    {
        return true;
    }
    
    // World 10 and above, all levels are unlcoked if world is unlocked
    if (worldId >= 10)
    {
        return false;
    }
    
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
        // All levels are unlocked if first 4 levels are complete
        return ![self getLevelCompleteState:worldId levelId:4];
    }
}

-(NSString*)getLevelLockedMessage:(int)worldId levelId:(int)levelId isFromPreviousLevel:(bool)isFromPreviousLevel
{
    assert([self getIsLevelLocked:worldId levelId:levelId]);
    
    NSString* mustCompletePreviousWorld = @"You must complete the first four levels of the previous world to unlock levels in this world.";
    
    NSString* mustCompletePreviousLevel = @"You must complete the previous level to unlock this level.";
    
    NSString* mustCompleteFirstFourLevel = @"You must complete the first four levels of this world to unlock this level.";
    
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

- (void)startMusic
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (!([@"Random" isEqualToString:[self getMusicSelection]]))
    {
        [[SoundManager sharedManager] stopMusic:false];
        [[SoundManager sharedManager] playMusic:[[self getMusicSelection] stringByAppendingString:@".mp3"]looping:YES];
    }
    else
    {
        // Random music
        int musicIndex = arc4random()%(self.musicTracks.count-1) + 1;
        NSString *music = [[self.musicTracks objectAtIndex:musicIndex] stringByAppendingString:@".mp3"];
        NSLog(@"Start playing random music: %@", music);
        [[SoundManager sharedManager] stopMusic:false];
        [[SoundManager sharedManager] playMusic:music looping:NO];
    }
    
    // Listen for sound finish playing
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(soundDidFinishPlaying:) name:@"SoundDidFinishPlayingNotification" object:nil];
}

-(void)soundDidFinishPlaying:(id)sender
{
    NSNotification *notification = (NSNotification*)sender;
    Sound *sound = (Sound*)notification.object;
    NSString *soundName = [sound.name substringToIndex:sound.name.length - 4];
    
    NSLog(@"Received sound finished playing notification: %@",
           soundName);
    
    // If we're playing random tracks and this is a music track that just finished playing
    if ([@"Random" isEqualToString:[self getMusicSelection]] &&
        [[[UserData sharedUserData] musicTracks] containsObject:soundName])
    {
        // Start playing another random track
        [self startMusic];
    }
}

@end
