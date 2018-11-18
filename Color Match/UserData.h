//
//  UserData.h
//  Color Match
//
//  Created by Linda Chen on 6/8/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

@property (nonatomic, retain) NSUserDefaults *userData;
@property NSArray *musicTracks;

+(id)sharedUserData;
+(NSMutableString*)getLevelString:(int)worldId levelId:(int)levelId;
-(void)storeLevelComplete:(int)worldId levelId:(int)levelId stars:(int)stars;
-(bool)getLevelCompleteState:(int)worldId levelId:(int)levelId;
-(int)getStarCount:(int)worldId levelId:(int)levelId;
-(void)wipeData;
-(int)getLastLevelCompletedInWorld;
-(void)storeLastLevelCompletedInWorld:(int)worldId;
-(void)storeTutorialComplete:(int)worldId;
-(bool)getTutorialComplete:(int)worldId;
-(void)storeGamePurchased:(bool)purchased;
-(bool)getGamePurchased;
-(bool)getIsLevelLocked:(int)worldId levelId:(int)levelId;
-(bool)getIsWorldLocked:(int)worldId;
-(NSString*)getLevelLockedMessage:(int)worldId levelId:(int)levelId isFromPreviousLevel:(bool)isFromPreviousLevel;
-(void)storeIsSoundEnabled:(bool)enabled;
-(bool)getIsSoundEnabled;
-(void)storeIsMusicEnabled:(bool)enabled;
-(bool)getIsMusicEnabled;
-(void)storeMusicSelection:(NSString*)musicSelection;
-(NSString*)getMusicSelection;
-(void)startMusic;

@end
